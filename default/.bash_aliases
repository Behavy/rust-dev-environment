alias c=clear


# Git aliases.
alias gst='git status'
alias gcm='git checkout main'
alias gp='git push'
alias gcam='git commit -a -m'
alias gcb='git checkout -b'
alias gcr='f() { git checkout -b $1 origin/$1; }; f'


build_watch_command() {
  eval "to_watch_list=\$$1"
  watch_command=""

  if [ ! -z $to_watch_list ]; then
    for towatch in ${to_watch_list[@]}; do
      if [ ! -d "$towatch" ]; then
        echo "The directory $towatch does not exist"
        return 1
      fi
      watch_command="$watch_command --watch $towatch"
    done
  else
    watch_command="--watch /workspace/crates"
  fi

  return $watch_command
}

# Cargo watch
ws() {
  watch_command=build_watch_command "ws_to_watch"

  cargo watch --quiet --clear $watch_command --exec "run services/api"
}

wt() {
  watch_command=build_watch_command "wt_to_watch"

  if [ -z "$1" ]; then
    cargo watch --quiet --clear $watch_command --exec "test -- --nocapture"
  else
    cargo watch --quiet --clear $watch_command --exec "test $1 -- --nocapture"
  fi

}

we() {
  watch_command=build_watch_command "we_to_watch"

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

  cargo watch --quiet --clear --watch /workspace/crates/services/api/examples/$1.rs $watch_command --delay $delay_seconds --exec "run --example $1"
}



# Database
alias sqlx='dbmate --no-dump-schema --migrations-dir /workspace/sql/migrations'
alias db='psql $DATABASE_URL'