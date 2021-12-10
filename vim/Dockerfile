FROM alpine:3.13.6

RUN apk add \
  gcc neovim vim curl git g++ \
  python3 py3-pip musl-dev python3-dev \
  nodejs npm
RUN sh -c 'curl -fLo /nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

RUN npm install -g neovim && \
  python3 -m ensurepip --default-pip && \
  python3 -m pip install --upgrade pynvim

COPY ./dotfiles/.vimrc /nvim/.vimrc
COPY ./dotfiles/.nvim.config /nvim/init.vim

RUN nvim -u /nvim/init.vim +PlugInstall! +qa

RUN chmod 777 -R /nvim

CMD ["nvim"]
