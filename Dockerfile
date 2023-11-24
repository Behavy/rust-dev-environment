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

ARG GIT_NAME=undefined
ARG GIT_EMAIL=undefined
ARG SSH_PATH

# Create directories
RUN mkdir -p $WORKSPACE_HOME/target


# Install dependencies
RUN apt update 
RUN apt upgrade
RUN apt -y install curl
RUN apt -y install gcc
RUN apt -y install git
RUN apt -y install pkg-config
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
RUN chmod -R a+w $RUSTUP_HOME $CARGO_HOME;
USER $USERNAME

# SSH setup
COPY $SSH_PATH /home/$USERNAME/.ssh

# Add project files
COPY . $WORKSPACE_HOME
WORKDIR $WORKSPACE_HOME

RUN cp $WORKSPACE_HOME/.devcontainer/.bashrc /home/$USERNAME/.bashrc
RUN cp $WORKSPACE_HOME/.devcontainer/.bash_aliases /home/$USERNAME/.bash_aliases

RUN git config --global --add safe.directory /workspace
RUN git config --global user.name $GIT_NAME
RUN git config --global user.email $GIT_EMAIL
# Enable our git hooks and set the permisisons on docker sock.
RUN echo 'git config core.hooksPath $WORKSPACE_HOME/.devcontainer/.githooks' >> ~/.bashrc