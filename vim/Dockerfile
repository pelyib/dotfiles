FROM golang:1.9.4-alpine AS gosrc

FROM ubuntu:22.10

ARG USER=docker
ARG UID=1000
ARG GID=1000
RUN adduser --uid ${UID} --gid ${GID} ${USER}

RUN apt update

RUN apt install -y \
  gcc vim curl git g++ \
  python3 python3-pip musl-dev python3-dev \
  nodejs npm

RUN npm install -g neovim && \
  python3 -m pip install --upgrade pynvim

COPY --from=gosrc /usr/local/go /usr/local/go
#ADD ./vendor/go1.19/go1.19.3.linux-amd64.tar.gz /usr/local
#RUN mkdir /gopath && \
#  GOPATH=/gopath /usr/local/go/bin/go install golang.org/x/tools/gopls@latest

ADD ./nvim-linux64.v0.8.1.tar.gz /nvim/
RUN cp -R /nvim/nvim-linux64/* /usr/

WORKDIR /home/${USER}

RUN chown -R ${USER} /home/${USER}/
USER ${UID}:${GID}

ENV PATH=$PATH:/usr/local/go/bin:/gopath/bin

CMD ["nvim"]
