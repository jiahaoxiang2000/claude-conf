#!/bin/sh
# Claude Code attention hook — runs for Notification and Stop events.
# Drives desktop notifications and tmux auto-focus directly, so no tmux
# config is required (apart from running inside tmux at all).
#
# Per-window "pending" state is tracked via a custom tmux window option
# (@claude_pending) set on Notification and cleared on Stop. Auto-focus
# only happens when this is the *only* pending window, to avoid two
# simultaneous notifications ping-ponging focus between their panes.

event="${1:-}"
log=/tmp/claude-attn.log

# Read hook JSON payload from stdin (Claude Code passes hook context here).
payload=""
if [ ! -t 0 ]; then
  payload=$(cat 2>/dev/null || true)
fi
# Extract a top-level string field from the JSON payload. Uses jq so multi-line
# fields like `output` (Claude's response body) are handled correctly.
extract() {
  printf '%s' "$payload" | jq -r ".${1} // empty" 2>/dev/null
}

# One-line preview of a possibly-multiline string, truncated to $2 chars.
preview() {
  printf '%s' "$1" | tr '\n' ' ' | tr -s ' ' | sed 's/^ //; s/ $//' | cut -c1-"${2:-140}"
}

printf '%s event=%s TMUX_PANE=%s pid=%s\n' \
  "$(date '+%F %T')" "$event" "${TMUX_PANE:-<unset>}" "$$" >> "$log"

[ -n "$TMUX_PANE" ] || exit 0  # nothing to do outside tmux

label=$(tmux display-message -p -t "$TMUX_PANE" '#W · #{b:pane_current_path}' 2>/dev/null)
pane_win=$(tmux display-message -p -t "$TMUX_PANE" '#{window_id}' 2>/dev/null)

case "$event" in
  notification)
    # Filtered to permission_prompt|idle_prompt by the settings.json matcher.
    tmux set-option -w -t "$TMUX_PANE" @claude_pending 1 2>/dev/null
    notify-send -u normal -t 10000 -a claude -i utilities-terminal \
      "Claude needs input" "$label"
    pending=$(tmux list-windows -a -F '#{@claude_pending}' 2>/dev/null | grep -c '^1$')
    [ "$pending" = 1 ] && tmux select-window -t "$pane_win"
    ;;
  stop)
    tmux set-option -w -t "$TMUX_PANE" -u @claude_pending 2>/dev/null
    # Stop payload has no `output`/`stop_reason` fields — pull the last
    # assistant text from the transcript JSONL instead.
    transcript=$(extract transcript_path)
    last_msg=""
    if [ -n "$transcript" ] && [ -f "$transcript" ]; then
      # The very last assistant entry is usually a tool_use with no text
      # block. Walk back through assistant entries and pick the most recent
      # one that actually contains user-visible text.
      last_msg=$(jq -rs '
        [ .[]
          | select(.type=="assistant")
          | (.message.content // [])
          | map(select(.type=="text") | .text) | join(" ")
          | select(length>0) ]
        | last // ""
      ' "$transcript" 2>/dev/null)
    fi
    snippet=$(preview "$last_msg" 140)
    body="$label"
    [ -n "$snippet" ] && body="$body
$snippet"
    notify-send -u normal -t 10000 -a claude -i utilities-terminal \
      "Claude Idea" "$body"
    ;;
  stop_failure)
    tmux set-option -w -t "$TMUX_PANE" -u @claude_pending 2>/dev/null
    err_type=$(extract error_type)
    err_msg=$(extract error_message)
    notify-send -u critical -a claude -i dialog-error \
      "Claude error: ${err_type:-unknown}" "${err_msg:-$label}"
    # Pull the user back so they can react to the failure.
    tmux select-window -t "$pane_win"
    ;;
  prompt_submit)
    # User just sent a new prompt — clear any stale pending marker so the
    # @claude_pending state stays in sync even if Stop ever misses.
    tmux set-option -w -t "$TMUX_PANE" -u @claude_pending 2>/dev/null
    ;;
esac
