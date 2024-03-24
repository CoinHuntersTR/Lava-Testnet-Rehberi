#!/bin/bash
# prune node
sudo systemctl stop lava.service
sleep 5
/root/go/bin/cosmprund prune ~/.lavad/data
sleep 5
# Make sure the service is running
sudo systemctl start lava.service
sleep 10
# Stop service
sudo systemctl stop lava.service
# Compress the folder
mkdir -p /var/www/html/snap/t/lavad
tar -cf - /root/.lava/data | lz4 - /var/www/html/snap/t/lava/snapshot_latest.tar.lz4 -f
#Copy Genesis & addrbook
cp /root/.lava/config/addrbook.json /var/www/html/snap/t/lava/
cp /root/.lava/config/genesis.json /var/www/html/snap/t/lava/
# Restart the service
sudo systemctl start lava.service
sleep 10
#Log json
rm -rf /var/www/html/snap/t/lava/log.json
set -e
now_date() {
    echo -n $(TZ=":Europe/Moscow" date '+%Y-%m-%d_%H:%M:%S')
}
log_this() {
    YEL='\033[1;33m' # yellow
    NC='\033[0m'     # No Color
    local logging="$@"
    printf " $logging\n" | tee -a /var/www/html/snap/t/lava/log.json
}
SIZE="$(du -sh /var/www/html/snap/t/lava/snapshot_latest.tar.lz4 | awk '{print $1}')"
DOWNLOAD="https:\/\/ss.coinhunterstr.com\/lava\/snapshot_latest.tar.lz4"
LAST_BLOCK_HEIGHT=$(curl -s http://localhost:14457/status | jq -r .result.sync_info.latest_block_height)
TIME=$(TZ=":Europe/Moscow" date '+%d-%m-%Y %H:%M')
NETWORK=$(curl -s http://localhost:14457/status | jq -r .result.node_info.network)
VERSION=$(curl -s http://localhost:14017/cosmos/base/tendermint/v1beta1/node_info | jq -r .application_version.version)
SDK_VERSION=$(curl -s http://localhost:14017/cosmos/base/tendermint/v1beta1/node_info | jq -r .application_version.cosmos_sdk_version)
log_this "[{"\"block"\":"\"${LAST_BLOCK_HEIGHT}"\", "\"time"\":"\"${TIME}"\","\"size"\":"\"${SIZE}"\","\"download"\":"\"${DOWNLOAD}"\","\"network"\":"\"${NETWORK}"\","\"version"\":"\"${VERSION}"\","\"sdk_version"\":"\"${SDK_VERSION}"\"}]"
