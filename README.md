# rust-dev-environment

## A - How to setup this environment

1. Copy the `to-copy` inside folders into your repository,
2. Set the environment variables in the `docker-compose.yml`,
3. Install the recommended vscode extensions ( `ms-vscode-remote.remote-containers` ),
4. Run the vscode in container by clicking in the bottom left corner and `open in the container`.

Et voilà 🪄✨

### Help - Environment variables

| variable | description |
|---|---|
| `GIT_NAME` | Yout git username |
| `GIT_EMAIL` | Your git email |
| `DATABASE_URL` | The database url used by the local server, the `db` and the `migrate` commands |
| `WS_BIN_NAME` | The executed binary using `ws` command |
| `WS_TO_WATCH` | The watched files using `ws` command |
| `WT_TO_WATCH` | The watched files using `wt` command |
| `EXAMPLES_FOLDER` | The example folder's path used by the `we` command |

## B - Installed packages

| name | version |
|---|---|
| curl | latest |
| git | latest |
| postgres-client | latest |
| rustup | latest |
| cargo | latest |
| cargo-watch | latest |
| cargo-udeps | latest |
| dbmate | 2.10.0 |

## C - Custom commands

### 1. Global

| command | description |
|---|---|
| `c` | clear |

### 2. Git

| command | description |
|---|---|
| `gst` | git status |
| `gcm` | git checkout main |
| `gp` | git push |
| `gcam` | git commit -a -m |
| `gcb` | git checkout -b |
| `gcr <branch>` | git checkout the given branch |

### 3. Cargo

| command | description |
|---|---|
| `ws` | watch the server |
| `wt (test)` | Run the given test or all of them if none is given |
| `we (example)` | Run the given example |
| `udeps` | Show unused dependencies |

### 4. Database

| command | description |
|---|---|
| `migrate` | Execute the DBMATE migration command based on the /workspace/sql/migrations folder |
| `db` | Connect to the postgres db |

## D - Create custom aliases

You can add your own aliases by writing them in a `.bash_aliases` file in the `.devcontainer` folder.

It's that simple. :)

## E - Building steps

### 1. Build and run the docker images

``` sh
docker-compose stop;
docker-compose rm;
docker-compose up -d;
```

### 2. Opening a terminal inside of the container

``` sh
docker exec -it devcontainer-development-1 bash;
```

### 3. Exit the container's terminal

``` sh
exit
```
