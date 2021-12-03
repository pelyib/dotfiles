FROM alpine:3.13.6

RUN apk add neovim vim curl git python3
RUN sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

WORKDIR /root

RUN mkdir .config .config/nvim

COPY ./dotfiles/.vimrc .vimrc
COPY ./dotfiles/.nvim.config .config/nvim/init.vim

RUN nvim +PlugInstall! +qa

CMD ["nvim"]
