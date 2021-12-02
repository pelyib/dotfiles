#!/usr/bin/env zsh

# remove everything if it is forced

# install plugin manager https://ohmyz.sh/#install
# RUNZSH=no will disable to open a new zsh shell right after the installation automatically
sh -c "RUNZSH=no $(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# install theme https://github.com/romkatv/powerlevel10k
# https://github.com/romkatv/powerlevel10k#oh-my-zsh
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# link files
[[ -f /app/dotfiles/.zshenv ]] && ln -s /app/dotfiles/.zshenv ~/.zshenv
[[ -f ~/.p10k.zsh ]] && mv ~/.p10k.zsh  ~/.p10k.zsh_pre
[[ -f ~/.zshrc ]] && mv ~/.zshrc ~/.zshrc_pre

ln -s /app/dotfiles/.p10k.zsh ~/.p10k.zsh
ln -s /app/dotfiles/.zshrc ~/.zshrc
