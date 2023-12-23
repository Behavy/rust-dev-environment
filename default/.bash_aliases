alias c=clear


# Git aliases.
alias gst='git status'
alias gcm='git checkout main'
alias gp='git push'
alias gcam='git commit -a -m'
alias gcb='git checkout -b'
alias gcr='f() { git checkout -b $1 origin/$1; }; f'


# Cargo watch
alias ws='cargo watch --quiet --clear --watch /workspace/crates/services/api/src/ --watch /workspace/.cargo/ --watch /workspace/crates/libs --watch /workspace/sql --exec run'

wt() {
  if [ -z "$1" ]; then
    cargo watch --quiet --clear --watch /workspace/crates/services/api/src/ --watch /workspace/crates/services/api/tests/ --exec "test -- --nocapture"
  else
    cargo watch --quiet --clear --watch /workspace/crates/services/api/src/ --watch /workspace/crates/services/api/tests/ --exec "test $1 -- --nocapture"
  fi

}

we() {

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

  cargo watch --quiet --clear --watch /workspace/crates/services/api/examples/$1.rs --watch /workspace/crates/services/api/src/ --watch /workspace/.cargo/ --watch /workspace/crates/libs --watch /workspace/sql --delay $delay_seconds --exec "run --example $1"
}



# Database
alias sqlx='dbmate --no-dump-schema --migrations-dir /workspace/sql/migrations'
alias db='psql $DATABASE_URL'
