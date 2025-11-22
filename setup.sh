#!/bin/bash
set -e

echo "=== Updating system ==="
sudo apt update -y
sudo apt upgrade -y

echo "=== Installing dependencies ==="
sudo apt install -y curl git apt-transport-https ca-certificates

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

echo "=== Node version ==="
node -v
npm -v

echo "=== Installing Caddy (official repo) ==="
sudo apt install -y debian-keyring debian-archive-keyring
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo tee /usr/share/keyrings/caddy-stable-archive-keyring.gpg >/dev/null
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list >/dev/null

sudo apt update -y
sudo apt install -y caddy

echo "=== Enabling & starting Caddy ==="
sudo systemctl enable caddy
sudo systemctl start caddy

echo "=== Installation complete ==="
echo "NVM, Node.js, npm, and Caddy are now installed."
