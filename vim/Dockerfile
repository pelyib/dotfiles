FROM alpine:3.13.6

RUN apk add \
  gcc neovim vim curl git g++ \
  python3 py3-pip musl-dev python3-dev \
  nodejs npm
RUN sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

RUN npm install -g neovim && \
  python3 -m ensurepip --default-pip && \
  python3 -m pip install --user --upgrade pynvim

WORKDIR /root

RUN mkdir .config/nvim

COPY ./dotfiles/.vimrc .vimrc
COPY ./dotfiles/.nvim.config .config/nvim/init.vim

RUN nvim +PlugInstall! +qa

CMD ["nvim"]
