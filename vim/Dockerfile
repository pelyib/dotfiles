FROM golang:1.19.4-alpine AS gosrc

# Install any GO apps here
RUN go install golang.org/x/tools/gopls@latest

FROM ubuntu:22.10

# Placeholders, they should be set in the Makefile
ARG USER=docker
ARG UID=1000
ARG GID=1000
RUN adduser --uid ${UID} --gid ${GID} ${USER}

ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt update

# Install dependencies for plugins and NeoVIM
RUN apt install -y \
  gcc vim curl git g++ zip unzip \
  python3 python3-pip musl-dev python3-dev \
  nodejs npm \
  php8.1-cli

# Install language helpers
RUN npm install -g neovim tree-sitter-cli vscode-langservers-extracted intelephense && \
  python3 -m pip install --upgrade pynvim

# Copy binaries and add them to the PATH
COPY --from=gosrc /usr/local/go /usr/local/go
COPY --from=gosrc /go /go
RUN echo "PATH=\"$PATH:/usr/local/go/bin:/go/bin\"" >> /etc/environment && \
  echo "PATH=\"$PATH:/usr/local/go/bin:/go/bin\"" >> /etc/profile && \
  echo "PATH=\"$PATH:/usr/local/go/bin:/go/bin\"" >> /etc/bash.bashrc
ENV GOPATH=/go
ENV PATH=$PATH:/usr/local/go/bin:/go/bin

# Copy Composer, PHP package manager
COPY --from=composer:2.5.1 /usr/bin/composer /usr/bin/composer

# Install NeoVIM
ADD ./nvim-linux64.v0.8.1.tar.gz /nvim/
RUN cp -R /nvim/nvim-linux64/* /usr

# Create working folder
RUN mkdir /data

COPY ./vendor /vendor

WORKDIR /home/${USER}

# Fix the permissions
RUN chown -R ${USER} /home/${USER}/
RUN usermod -aG sudo ${USER}
USER ${UID}:${GID}

CMD ["nvim", "/data"]
