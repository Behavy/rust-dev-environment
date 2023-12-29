# rust-dev-environment

## A - How to setup this environment

1. Copy the `to-copy` inside folders into your repository,
2. Set the environment variables in the `docker-compose.yml`,
3. Install the recommended vscode extensions ( `ms-vscode-remote.remote-containers` ),
4. Run the vscode in container by clicking in the bottom left corner and `open in the container`.

Et voilà 🪄✨

## B - Installed packages

| name | version |
|---|---|
| curl | latest |
| git | latest |
| postgres-client | latest |
| rustup | latest |
| cargo | latest |
| sqlx-cli | latest |

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

### 4. Database

| command | description |
|---|---|
| `migrate` | todo : sqlx ci migration |
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
