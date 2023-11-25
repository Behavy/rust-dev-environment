# rust-dev-environment

## A - How to use this environment

1. Copy the "to-copy" folders into your repository
2. Set the environment variables in the `docker-compose.yml`
3. Install the recommended vscode extensions ( `ms-vscode-remote.remote-containers` )
4. Run the vscode in container by clicking in the bottom left corner and `open in the container`.

## B - Building steps

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

