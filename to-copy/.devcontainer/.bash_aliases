# Git aliases.
alias gst='git status'
alias gcm='git checkout main'
alias c=clear
alias gp='git push'
alias gcam='git commit -a -m'
alias gpsup="git push --set-upstream origin $(git symbolic-ref -q HEAD | sed -e 's|^refs/heads/||')"
alias gcb='git checkout -b'
alias gcr='f() { git checkout -b $1 origin/$1; }; f'
alias gitsetup='git config --global user.name \$NAME && git config --global user.email \$EMAIL'

# Cargo watch
alias ws='cargo watch -q -c -w /workspace/crates/api/src/ -w /workspace/.cargo/ -w /workspace/crates/api/src -w /workspace/crates/api/sql -w /workspace/crates/log/src -x run'

wt() {
  if [ -z "$1" ]; then
    cargo watch -q -c -w /workspace/crates/api/src/ -w /workspace/crates/api/tests/ -x "test -- --nocapture"
  else
    cargo watch -q -c -w /workspace/crates/api/src/ -w /workspace/crates/api/tests/ -x "test $1 -- --nocapture"
  fi

}

we() {
  
  if [ -z "$1" ]; then
    echo "Please provide the name of the example you want to run"
    echo "Available examples are:\n"
    ls /workspace/crates/api/examples | sed 's/\.rs//'
    return 1
  fi

  if [ ! -f "/workspace/crates/api/examples/$1.rs" ]; then
    echo "Please provide the name of the example you want to run"
    echo "Available examples are:\n"
    ls /workspace/crates/api/examples | sed 's/\.rs//'
    return 1
  fi

  cargo watch -q -c -w /workspace/crates/api/examples/$1.rs -x "run --example $1"
}



# Database
alias sqlx='dbmate --no-dump-schema --migrations-dir /workspace/crates/db/migrations' # TODO
alias db='psql $DATABASE_URL'
