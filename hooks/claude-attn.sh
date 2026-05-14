#!/bin/sh
# Claude Code attention hook — runs for Notification, Stop, StopFailure,
# and UserPromptSubmit events.
#
# Behavior:
#   * notify-send fires for every event (tmux-attached AND background sessions).
#   * tmux-specific actions (pending-window marker, auto-focus) only run when
#     the hook fires inside a tmux pane.
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

# Build a notification label. In tmux, use window name + cwd basename.
# Outside tmux (background sessions), fall back to cwd basename + short session id.
pane_win=""
if [ -n "$TMUX_PANE" ]; then
  label=$(tmux display-message -p -t "$TMUX_PANE" '#W · #{b:pane_current_path}' 2>/dev/null)
  pane_win=$(tmux display-message -p -t "$TMUX_PANE" '#{window_id}' 2>/dev/null)
else
  cwd=$(extract cwd)
  sid=$(extract session_id)
  if [ -n "$cwd" ]; then
    label="${cwd##*/}"
  else
    label="claude"
  fi
  # append first 8 chars of session id when present
  if [ -n "$sid" ]; then
    short_sid=$(printf '%s' "$sid" | cut -c1-8)
    label="$label · bg:$short_sid"
  fi
fi

# notify-send wrapper that no-ops if the binary is missing.
notify() {
  command -v notify-send >/dev/null 2>&1 || return 0
  notify-send "$@"
}

case "$event" in
  notification)
    # Filtered to permission_prompt|idle_prompt by the settings.json matcher.
    [ -n "$TMUX_PANE" ] && tmux set-option -w -t "$TMUX_PANE" @claude_pending 1 2>/dev/null
    notify -u normal -t 10000 -a claude -i utilities-terminal \
      "Claude needs input" "$label"
    if [ -n "$TMUX_PANE" ]; then
      pending=$(tmux list-windows -a -F '#{@claude_pending}' 2>/dev/null | grep -c '^1$')
      [ "$pending" = 1 ] && tmux select-window -t "$pane_win"
    fi
    ;;
  stop)
    [ -n "$TMUX_PANE" ] && tmux set-option -w -t "$TMUX_PANE" -u @claude_pending 2>/dev/null
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
    notify -u normal -t 10000 -a claude -i utilities-terminal \
      "Claude Idea" "$body"
    ;;
  stop_failure)
    [ -n "$TMUX_PANE" ] && tmux set-option -w -t "$TMUX_PANE" -u @claude_pending 2>/dev/null
    err_type=$(extract error_type)
    err_msg=$(extract error_message)
    notify -u critical -a claude -i dialog-error \
      "Claude error: ${err_type:-unknown}" "${err_msg:-$label}"
    # Pull the user back so they can react to the failure (tmux only).
    [ -n "$TMUX_PANE" ] && [ -n "$pane_win" ] && tmux select-window -t "$pane_win"
    ;;
  prompt_submit)
    # User just sent a new prompt — clear any stale pending marker so the
    # @claude_pending state stays in sync even if Stop ever misses.
    [ -n "$TMUX_PANE" ] && tmux set-option -w -t "$TMUX_PANE" -u @claude_pending 2>/dev/null
    ;;
esac
