#!/bin/bash
adirScript="$( cd "$( dirname "$${BASH_SOURCE[0]}" )" && pwd )"

apt-get update
apt-get install wget
wget -qO- https://get.docker.com/ | sh
usermod -aG docker ubuntu
service docker start
#newgrp docker

dockerComposeVersion=1.25.4
curl -L "https://github.com/docker/compose/releases/download/$dockerComposeVersion/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

apt-get install git
cd "$adirScript"
git clone https://github.com/mattermost/mattermost-docker.git /mattermost-docker-build

cp "$adirScript/docker-compose.yml" "/mattermost-docker-build/docker-compose.yml"
cd /mattermost-docker-build
docker-compose build
mkdir -pv ./volumes/app/mattermost/{data,logs,config,plugins,client-plugins}
sudo chown -R 2000:2000 ./volumes/app/mattermost/

bash "$${adirScript}/run.sh.sh"
bash "$${adirScript}/run.sh"