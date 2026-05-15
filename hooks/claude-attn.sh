#!/bin/sh
# Claude Code attention hook — runs for Notification, Stop, and StopFailure
# events. Fires notify-send for every event.

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

printf '%s event=%s pid=%s\n' \
  "$(date '+%F %T')" "$event" "$$" >> "$log"

# Build a notification label from cwd basename + short session id.
cwd=$(extract cwd)
sid=$(extract session_id)
if [ -n "$cwd" ]; then
  label="${cwd##*/}"
else
  label="claude"
fi
if [ -n "$sid" ]; then
  short_sid=$(printf '%s' "$sid" | cut -c1-8)
  label="$label · bg:$short_sid"
fi

# notify-send wrapper that no-ops if the binary is missing.
notify() {
  command -v notify-send >/dev/null 2>&1 || return 0
  notify-send "$@"
}

case "$event" in
  notification)
    notify -u normal -t 10000 -a claude -i utilities-terminal \
      "Claude needs input" "$label"
    ;;
  stop)
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
    err_type=$(extract error_type)
    err_msg=$(extract error_message)
    notify -u critical -a claude -i dialog-error \
      "Claude error: ${err_type:-unknown}" "${err_msg:-$label}"
    ;;
esac
