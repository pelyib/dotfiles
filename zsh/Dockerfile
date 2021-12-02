FROM alpine:3.13.6

RUN apk update && \
    apk add zsh curl git

RUN mkdir /app

COPY ./dotfiles /app/dotfiles
COPY ./installer.sh /app/installer.sh

WORKDIR /app

CMD ["zsh"]