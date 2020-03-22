#!/bin/bash
adirScript="$( cd "$( dirname "$${BASH_SOURCE[0]}" )" && pwd )"
cat > $${adirScript}/run.sh <<"EOFRUN"

cd /mattermost-docker-build
docker-compose up -d
EOFRUN
