FROM debian:latest

# Environment variables
ENV USERNAME=vscode
ENV USER_UID=1000
ENV USER_GID=1000

ENV RUSTUP_HOME=/usr/local/.rustup
ENV CARGO_HOME=/usr/local/.cargo
ENV RUST_VERSION=1.73.0

ENV WORKSPACE_HOME=/workspace

ENV DEBIAN_FRONTEND=noninteractive

ENV PATH=$CARGO_HOME/bin:$PATH

ARG SSH_PUBLIC_KEY_PATH=

# Create directories
RUN mkdir -p /workspace/target


# Install dependencies
RUN apt update 
RUN apt upgrade
RUN apt -y install curl
RUN apt -y install gcc
RUN apt -y install git
RUN apt autoremove -y
RUN apt clean -y     
RUN rm -r /var/cache/* /var/lib/apt/lists/*     


# -- Rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain $RUST_VERSION

RUN cargo install cargo-watch
RUN cargo install sqlx-cli --no-default-features --features postgres


# User setup
RUN groupadd --gid $USER_GID $USERNAME
RUN useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME
RUN chown -R $USERNAME:$USERNAME /workspace
USER $USERNAME


# Add project files
COPY . /workspace
WORKDIR /workspace

RUN cp .devcontainer/.bashrc /home/$USERNAME/.bashrc
RUN cp .devcontainer/.bash_aliases /home/$USERNAME/.bash_aliases

# Enable our git hooks and set the permisisons on docker sock.
RUN echo 'git config core.hooksPath /workspace/.devcontainer/.githooks' >> ~/.bashrc


# Default command
CMD [ "tail", "-f", "/dev/null"]
CMD ["bash"]


# TODO : Supprimer
# RUN |8 CLOAK_VERSION=1.19.4 DBMATE_VERSION=2.7.0 MOLD_VERSION=2.3.2 EARTHLY_VERSION=0.7.21 DOCKER_COMPOSE_VERSION=2.23.0 USERNAME=vscode USER_UID=1000 USER_GID=1000 /bin/sh -c apt-get -y update     
# RUN apt-get install -y --no-install-recommends         git         curl         wget         ssh         sudo         jq         build-essential         protobuf-compiler         musl-dev         musl-tools         musl         apt-transport-https         ca-certificates         gnupg-agent         gnupg         software-properties-common         postgresql-client         npm         nodejs     
# RUN install -m 0755 -d /etc/apt/keyrings     
# RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg     
# RUN chmod a+r /etc/apt/keyrings/docker.gpg     
# RUN curl -fsSL "https://download.docker.com/linux/debian/gpg" | apt-key add -     
# RUN echo         "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian         "$(. /etc/os-release 
# RUN echo "$VERSION_CODENAME")" stable" |         tee /etc/apt/sources.list.d/docker.list > /dev/null     
# RUN apt-get -y --no-install-recommends install docker-ce docker-ce-cli containerd.io     
# RUN chmod 0440 /etc/sudoers.d/$USERNAME     
# RUN curl -L https://github.com/docker/compose/releases/download/v$DOCKER_COMPOSE_VERSION/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose     
# RUN chmod +x /usr/local/bin/docker-compose     