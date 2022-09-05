# GIT dotfiles

## Installation

- make a copy of [.gitconfig.dist](.gitconfig.dist) and remove `.dist` from the filename
- change what you need
- copy or link to your home folder

## Hooks

### pre-commit-jira

Validate the status of the ticket from the last commit message and stop the action if it is not valid.

To use it you need to specify some environment variable:
- JIRA_USER_NAME: user name of the JIRA user
- JIRA_USER_PASSWD: password of the JIRA user
- JIRA_DOMAIN: JIRA server domain

For it you can use the [.zshenv](zsh/dotfiles/.zshenv.dist) file.
