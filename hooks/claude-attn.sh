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
printf '%s event=%s TMUX_PANE=%s pid=%s\n' "$(date '+%F %T')" "$event" "${TMUX_PANE:-<unset>}" "$$" >> "$log"

[ -n "$TMUX_PANE" ] || exit 0  # nothing to do outside tmux

label=$(tmux display-message -p -t "$TMUX_PANE" '#{session_name} · #{window_name}' 2>/dev/null)
pane_win=$(tmux display-message -p -t "$TMUX_PANE" '#{window_id}' 2>/dev/null)

case "$event" in
  notification)
    tmux set-option -w -t "$TMUX_PANE" @claude_pending 1 2>/dev/null
    notify-send -u normal -t 10000 -a claude -i utilities-terminal \
      "Claude needs input" "$label"
    pending=$(tmux list-windows -a -F '#{@claude_pending}' 2>/dev/null | grep -c '^1$')
    [ "$pending" = 1 ] && tmux select-window -t "$pane_win"
    ;;
  stop)
    tmux set-option -w -t "$TMUX_PANE" -u @claude_pending 2>/dev/null
    notify-send -u normal -t 5000 -a claude -i utilities-terminal \
      "Claude Idea" "$label"
    ;;
esac
