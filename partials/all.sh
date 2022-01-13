#!/usr/bin/env bash
set -euo pipefail

bash <(curl -sL https://raw.github.com/imbolc/server-setup/master/partials/tools.sh)
bash <(curl -sL https://raw.github.com/imbolc/server-setup/master/partials/vimify.sh)
bash <(curl -sL https://raw.github.com/imbolc/server-setup/master/partials/vimrc.sh)
bash <(curl -sL https://raw.github.com/imbolc/server-setup/master/partials/tmux.sh)
bash <(curl -sL https://raw.github.com/imbolc/server-setup/master/partials/git.sh)
bash <(curl -sL https://raw.github.com/imbolc/server-setup/master/partials/aliases.sh)

echo -e "\033[0;32mAll partials run successfully\033[0m"
