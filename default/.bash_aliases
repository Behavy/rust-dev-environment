alias c=clear


# Git aliases.
alias gst='git status'
alias gcm='git checkout main'
alias gp='git push'
alias gcam='git commit -a -m'
alias gcb='git checkout -b'
alias gcr='f() { git checkout -b $1 origin/$1; }; f'


build_watch_command() {
  eval "to_watch=\$$1"
  IFS=","
  result=""

  if [ -z "$to_watch" ]; then
    >&2 echo "WARNING: The list of directories to watch is empty"
    >&2 echo "WARNING: Watching the current directory instead"
    $to_watch="."
  fi

  for element in $to_watch; do
    if [ ! -d "$element" ]; then
      >&2 echo "ERROR: The directory $element does not exist"
      return 1
    fi
    echo "Watching file: $element"
    result="$result --watch $element"
  done

  return 0
}

# Cargo watch
ws() {
  result=""
  build_watch_command WS_TO_WATCH $result

  echo "cargo watch --quiet --clear $result --exec \"run --bin $WS_BIN_NAME\""
  eval cargo watch --quiet --clear $result --exec "run --bin $WS_BIN_NAME"
}

wt() {
  result=""
  build_watch_command WT_TO_WATCH $result

  if [ -z "$1" ]; then
    echo "cargo watch --quiet --clear $result --exec \"test -- --nocapture\""
    cargo watch --quiet --clear $result --exec "test -- --nocapture"
  else
    echo "cargo watch --quiet --clear $result --exec \"test $1 -- --nocapture\""
    eval cargo watch --quiet --clear $result --exec "test $1 -- --nocapture"
  fi

}

we() {
  result=""
  build_watch_command WS_TO_WATCH $result

  delay_seconds=10
  
  if [ -z "$1" ] || [ ! -f "$EXAMPLES_FOLDER/$1.rs" ]; then
    echo "Please provide the name of the example you want to run"
    echo "Available examples are:"
    ls $EXAMPLES_FOLDER | sed 's/\.rs//'
    return 1
  fi

  if [ ! -z "$2" ]; then
    delay_seconds=$2
  fi

  echo "cargo watch --quiet --clear --watch /workspace/crates/services/api/examples/$1.rs $result --delay $delay_seconds --exec \"run --example $1\""
  eval cargo watch --quiet --clear --watch /workspace/crates/services/api/examples/$1.rs $result --delay $delay_seconds --exec "run --example $1"
}



# Database
alias sqlx='dbmate --no-dump-schema --migrations-dir /workspace/sql/migrations'
alias db='psql $DATABASE_URL'
