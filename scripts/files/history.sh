#!/bin/bash
# Global bash history configuration — deployed to /etc/profile.d/history.sh
# This file is automatically sourced for all users on login.

# Include timestamps with every history entry: YYYY-MM-DD HH:MM:SS
export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "

# Number of commands to remember in memory during the session
export HISTSIZE=10000

# Number of commands to store in the history file (~/.bash_history)
export HISTFILESIZE=20000

# Don't store duplicate consecutive commands or commands starting with a space
export HISTCONTROL=ignoredups:ignorespace

# Append to the history file on logout instead of overwriting it
shopt -s histappend

# Write every command to the history file immediately (not just on logout)
# This means history is always up to date, even if the session crashes
export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
