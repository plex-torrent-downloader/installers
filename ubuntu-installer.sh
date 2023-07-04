#!/bin/bash
if [[ -d "/opt/plextorrentdownloader" ]]; then
    echo "Updating Plex torrent downloader..."
    cd /opt/plextorrentdownloader
    sudo git pull origin master
    sudo npm i
    sudo npx prisma generate
    sudo npx prisma migrate deploy
    sudo npm run build
    sudo systemctl restart torrentdownloader
    echo "Plex torrent downloader updated!"
    exit 1;
fi
echo "Installing Plex torrent downloader..."
# Check if Node.js is installed
node_installed=$(command -v npm)
sudo apt-get update
sudo apt-get install -y git
# If Node.js is not installed
if [ -z "$node_installed" ]; then
    echo "Node.js is not installed. Installing now..."
    sudo apt-get install -y curl nodejs npm
fi
sudo npm i -g n
sudo n 16
echo "Node.js has been installed successfully."
curl https://raw.githubusercontent.com/plex-torrent-downloader/installers/master/torrentdownloader.service > torrentdownloader.servic
sudo cp torrentdownloader.service /etc/systemd/system/
sudo mkdir /opt/plextorrentdownloader
sudo chmod -R 755 /opt/plextorrentdownloader
sudo git clone https://github.com/plex-torrent-downloader/plex-torrent-downloader.git /opt/plextorrentdownloader
cd /opt/plextorrentdownloader
echo "Installing packages"
sudo npm i
sudo cp .env.example .env
set PRISMA_CLI_QUERY_ENGINE_TYPE=binary
sudo npx prisma generate
sudo npx prisma migrate deploy
sudo npm run build
sudo systemctl enable torrentdownloader
sudo systemctl start torrentdownloader
echo "Plex Torrent Downloader Installed!"
