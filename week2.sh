#!/bin/bash

# Colors
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${GREEN}📦 Octra CLI Installer — Proot/Termux/PC Edition${NC}"
sudo apt update && apt upgrade -y
sudo apt install -y python3 python3-pip python3-venv python3-dev git curl
cd ~
if [ -d "~/octra_pre_client" ]; then
  echo -e "${GREEN}🔄 Updating existing repo...${NC}"
  cd ~/octra_pre_client
  git pull
else
  echo -e "${GREEN}📥 Cloning fresh repo...${NC}"
  git clone https://github.com/octra-labs/octra_pre_client.git
  cd ~/octra_pre_client
fi

if [ ! -d "venv" ]; then
  python3 -m venv venv
fi
source venv/bin/activate

pip install --upgrade pip
pip install -r requirements.txt
echo -e "${GREEN}🔑 Paste your private key:${NC}"
read -r my_priv_key

echo -e "${GREEN}📬 Paste your Octra address (starts with oct...):${NC}"
read -r my_addr

cat <<EOF > wallet.json
{
  "priv": "$my_priv_key",
  "addr": "$my_addr",
  "rpc": "https://octra.network"
}
EOF


echo -e "${GREEN}✅ wallet.json created with your private key & address.${NC}"
cd ~/octra_pre_client && source venv/bin/activate && python3 cli.py
