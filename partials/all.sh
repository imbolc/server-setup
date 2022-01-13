#!/usr/bin/env bash
set -euo pipefail

bash <(curl -sL https://raw.github.com/imbolc/server-setup/master/partials/tools.sh)
bash <(curl -sL https://raw.github.com/imbolc/server-setup/master/partials/vimification.sh)
bash <(curl -sL https://raw.github.com/imbolc/server-setup/master/partials/vim.sh)
bash <(curl -sL https://raw.github.com/imbolc/server-setup/master/partials/tmux.sh)
bash <(curl -sL https://raw.github.com/imbolc/server-setup/master/partials/git.sh)
bash <(curl -sL https://raw.github.com/imbolc/server-setup/master/partials/aliases.sh)

echo -e "\033[0;32mOK: \033[0mall partials run successfully"
