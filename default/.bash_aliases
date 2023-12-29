alias c=clear


# Git aliases.
alias gst='git status'
alias gcm='git checkout main'
alias gp='git push'
alias gcam='git commit -a -m'
alias gcb='git checkout -b'
alias gcr='f() { git checkout -b $1 origin/$1; }; f'


build_watch_command() {
  eval to_watch_list=\${$1[*]}
  result=""

  if [ -z "$to_watch_list" ]; then
    >&2 echo "WARNING: The list of directories to watch is empty"
    >&2 echo "WARNING: Watching the current directory instead"
    to_watch_list=[.]
  fi

  for towatch in ${to_watch_list[@]}; do
    if [ ! -d "$towatch" ]; then
      >&2 echo "ERROR: The directory $towatch does not exist"
      return 1
    fi
    echo "Watching file: $towatch"
    result="$result --watch $towatch"
  done

  return 0
}

# Cargo watch
ws() {
  result=""
  build_watch_command ws_to_watch $result

  cargo watch --quiet --clear $result --exec "run --bin $ws_bin_name"
}

wt() {
  result=""
  build_watch_command wt_to_watch $result

  if [ -z "$1" ]; then
    cargo watch --quiet --clear $result --exec "test -- --nocapture"
  else
    cargo watch --quiet --clear $result --exec "test $1 -- --nocapture"
  fi

}

we() {
  result=""
  build_watch_command ws_to_watch $result

  delay_seconds=10
  
  if [ -z "$1" ] || [ ! -f "/workspace/crates/services/api/examples/$1.rs" ]; then
    echo "Please provide the name of the example you want to run"
    echo "Available examples are:"
    ls /workspace/crates/services/api/examples | sed 's/\.rs//'
    return 1
  fi

  if [ ! -z "$2" ]; then
    delay_seconds=$2
  fi

  cargo watch --quiet --clear --watch /workspace/crates/services/api/examples/$1.rs $result --delay $delay_seconds --exec "run --example $1"
}



# Database
alias sqlx='dbmate --no-dump-schema --migrations-dir /workspace/sql/migrations'
alias db='psql $DATABASE_URL'
