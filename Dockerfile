FROM debian:latest

# Environment variables
ENV USERNAME=vscode
ENV USER_UID=1000
ENV USER_GID=1000

ENV RUSTUP_HOME=/usr/local/.rustup
ENV CARGO_HOME=/usr/local/.cargo
ENV RUST_VERSION=1.74.0

ENV DBMATE_VERSION=2.10.0

ENV WORKSPACE_HOME=/workspace

ENV DEBIAN_FRONTEND=noninteractive

ENV PATH=$CARGO_HOME/bin:$PATH

ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=$LANGUAGE

ARG GIT_NAME=undefined
ARG GIT_EMAIL=undefined


# Create directories
RUN mkdir -p $WORKSPACE_HOME/target 


# Install dependencies
RUN apt update 
RUN apt upgrade
RUN apt -y install locales
RUN apt -y install curl
RUN apt -y install gcc
RUN apt -y install git
RUN apt -y install pkg-config
RUN apt -y install libssl-dev
RUN apt -y install postgresql-client
RUN apt autoremove -y
RUN apt clean -y     
RUN rm -r /var/cache/* /var/lib/apt/lists/*     
# Install dbmate
RUN curl -fsSL -o /usr/local/bin/dbmate https://github.com/amacneil/dbmate/releases/download/v$DBMATE_VERSION/dbmate-linux-amd64
RUN chmod +x /usr/local/bin/dbmate


# Set locale
RUN echo $LANGUAGE >> /etc/locale.gen UTF-8
RUN locale-gen
RUN dpkg-reconfigure locales


# Install rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain $RUST_VERSION

RUN rustup component add rust-src
RUN rustup toolchain install nightly

RUN cargo install cargo-watch
RUN cargo install cargo-udeps


# User setup
RUN groupadd --gid $USER_GID $USERNAME
RUN useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME
RUN chown -R $USERNAME:$USERNAME $WORKSPACE_HOME 
RUN chown -R $USERNAME:$USERNAME /home/$USERNAME
RUN chown -R $USERNAME:$USERNAME $CARGO_HOME


# Add project files
COPY . /tmp/environment
RUN cp /tmp/environment/default/.bashrc /home/$USERNAME/.bashrc
RUN cp /tmp/environment/default/.bash_aliases /home/$USERNAME/.bash_aliases
RUN rm -rf /tmp/environment


# Git setup
RUN git config --global --add safe.directory /workspace
RUN git config --global user.name $GIT_NAME
RUN git config --global user.email $GIT_EMAIL



# Switch to user
USER $USERNAME


# Set workdir
WORKDIR $WORKSPACE_HOME
