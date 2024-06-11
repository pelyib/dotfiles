#!/usr/bin/env zsh

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# remove everything if it is forced

# install plugin manager https://ohmyz.sh/#install
# RUNZSH=no will disable to open a new zsh shell right after the installation automatically
if [[ ! -d "/Users/botond/.oh-my-zsh" ]]; then
  echo "Install oh-my-zsh"
  sh -c "RUNZSH=no $(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "oh-my-zsh already installed"
fi
echo ""

# install theme https://github.com/romkatv/powerlevel10k
# https://github.com/romkatv/powerlevel10k#oh-my-zsh
if [[ ! -d ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k ]]; then
  echo "Install powerlevel10k"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
else
  echo "powelevel10 already installed"
fi
echo ""

# link files
echo "Backup existing files"
[[ -f ~/.p10k.zsh ]] && mv ~/.p10k.zsh  ~/.p10k.zsh_pre
[[ -f ~/.zshrc ]] && mv ~/.zshrc ~/.zshrc_pre

#echo "Install"
[[ -f ${SCRIPT_DIR}/dotfiles/.zshenv ]] && ln -s ${SCRIPT_DIR}/dotfiles/.zshenv ~/.zshenv
ln -s ${SCRIPT_DIR}/dotfiles/.p10k.zsh ~/.p10k.zsh
ln -s ${SCRIPT_DIR}/dotfiles/.zshrc ~/.zshrc

echo ""
echo "Done"
echo ""
