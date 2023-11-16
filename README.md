# rust-dev-environment

## A - Steps

### 1. Build and run the docker images

``` sh
docker rm -f rust-dev-environment;
docker-compose up -id;
```

### 2. Running a container from the image we built

``` sh
docker rm -f rust-dev
docker run --name rust-dev --detach --interactive rust-dev-image
```

### 3. Opening a terminal inside of the container

``` sh
docker exec -it rust-dev bash
```

### 4. Exit the container's terminal

``` sh
exit
```
