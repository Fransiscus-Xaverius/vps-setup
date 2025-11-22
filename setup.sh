#!/bin/bash
set -e

echo "=== Updating system ==="
sudo apt update -y
sudo apt upgrade -y

echo "=== Installing base dependencies ==="
sudo apt install -y curl git apt-transport-https ca-certificates debian-keyring debian-archive-keyring

###############################################################################
# NVM + NODE + NPM
###############################################################################
echo "=== Installing NVM ==="
if [ ! -d "$HOME/.nvm" ]; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
else
  echo "NVM already installed, skipping..."
fi

echo "=== Loading NVM ==="
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

echo "=== Installing latest Node.js LTS ==="
nvm install --lts
nvm use --lts
nvm alias default lts/*

echo "Node version: $(node -v)"
echo "NPM version:  $(npm -v)"

###############################################################################
# CADDY INSTALL 
###############################################################################
echo "=== Installing Caddy ==="

# Remove previous broken repo (if any)
sudo rm -f /etc/apt/sources.list.d/caddy-stable.list

# Add official GPG key
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' \
  | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg

# Add repository
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' \
  | sudo tee /etc/apt/sources.list.d/caddy-stable.list >/dev/null

sudo apt update -y
sudo apt install -y caddy

echo "=== Enabling & starting Caddy ==="
sudo systemctl enable --now caddy

###############################################################################
# MYSQL INSTALL (non-interactive)
###############################################################################
echo "=== Installing MySQL Server ==="

# Preseed MySQL root password (empty password by default)
export DEBIAN_FRONTEND=noninteractive
sudo apt install -y mysql-server

echo "=== Securing MySQL installation ==="
sudo mysql --execute="
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '';
FLUSH PRIVILEGES;
"

echo "=== MySQL Installed ==="
echo "To set a password later, run:"
echo "  sudo mysql_secure_installation"

###############################################################################
# DONE
###############################################################################
echo "=== Installation complete ==="
echo "Installed: NVM, Node.js, npm, Caddy, MySQL."
