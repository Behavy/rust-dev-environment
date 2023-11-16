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
RUN mkdir -p $WORKSPACE_HOME/target


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
RUN chown -R $USERNAME:$USERNAME $WORKSPACE_HOME
USER $USERNAME


# Add project files
COPY . $WORKSPACE_HOME
WORKDIR $WORKSPACE_HOME

COPY .bashrc /home/$USERNAME/.bashrc
COPY .bash_aliases /home/$USERNAME/.bash_aliases

# Enable our git hooks and set the permisisons on docker sock.
RUN echo 'git config core.hooksPath $WORKSPACE_HOME/.devcontainer/.githooks' >> ~/.bashrc


# Default command
CMD [ "tail", "-f", "/dev/null"]
CMD ["bash"]


# TODO : Supprimer
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