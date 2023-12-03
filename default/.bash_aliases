alias c=clear


# Git aliases.
alias gst='git status'
alias gcm='git checkout main'
alias gp='git push'
alias gcam='git commit -a -m'
alias gcb='git checkout -b'
alias gcr='f() { git checkout -b $1 origin/$1; }; f'


# Cargo watch
alias ws='cargo watch -q -c -w /workspace/crates/api/src/ -w /workspace/.cargo/ -w /workspace/crates/api/src -w /workspace/crates/log/src -w /workspace/sql -x run'

wt() {
  if [ -z "$1" ]; then
    cargo watch -q -c -w /workspace/crates/api/src/ -w /workspace/crates/api/tests/ -x "test -- --nocapture"
  else
    cargo watch -q -c -w /workspace/crates/api/src/ -w /workspace/crates/api/tests/ -x "test $1 -- --nocapture"
  fi

}

we() {
  
  if [ -z "$1" ] || [ ! -f "/workspace/crates/api/examples/$1.rs" ]; then
    echo "Please provide the name of the example you want to run"
    echo "Available examples are:"
    ls /workspace/crates/api/examples | sed 's/\.rs//'
    return 1
  fi

  sleep 2; cargo watch -q -c -w /workspace/crates/api/examples/$1.rs -w /workspace/crates/api/src/ -w /workspace/.cargo/ -w /workspace/crates/api/src -w /workspace/crates/log/src -w /workspace/sql -x "run --example $1"
}



# Database
alias sqlx='dbmate --no-dump-schema --migrations-dir /workspace/crates/db/migrations'
alias db='psql $DATABASE_URL'
