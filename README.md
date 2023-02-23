<h1 align="center">Lava-Testnet-Rehberi

### Lava Node testini kuruyoruz. Sağ üstten yıldızlayıp forklamayı unutmayalım. Sorularınız olursa: <a href="https://t.me/CoinHuntersTR/34102" target="_blank" rel="Coin Hunters TR" >Coin Hunters TR</a>

![lava-network-testnet-rehberi](https://user-images.githubusercontent.com/111747226/220886500-561d6199-3c6d-4af3-8a45-b003ac7768ba.png)

## Sistem gereksinimleri:
NODE TİPİ | CPU     | RAM      | SSD     |
| ------------- | ------------- | ------------- | -------- |
| Full | 4          | 8         | 100  |


## 1) Güncellemeleri Yapıyoruz.

```
sudo apt update && sudo apt upgrade -y
```
```
sudo apt install -y unzip logrotate git jq sed wget curl coreutils systemd
```
```
temp_folder=$(mktemp -d) && cd $temp_folder
```
## 2) Go Kurulumu Yapıyoruz

```
go_package_url="https://go.dev/dl/go1.18.linux-amd64.tar.gz"
```
```
go_package_file_name=${go_package_url##*\/}
```
> Go indiriyoruz.
```
wget -q $go_package_url
```
```
sudo tar -C /usr/local -xzf $go_package_file_name
```
```
echo "export PATH=\$PATH:/usr/local/go/bin" >>~/.profile
```
```
 source ~/.profile
```

## 3) Node Kurulumuna Geçiyoruz.

```
git clone https://github.com/lavanet/lava-config.git
```
```
cd lava-config/testnet-1
```
```
source setup_config/setup_config.sh
```

## 4) Node yapılandırmalarına devam ediyoruz.
  
```
echo "Lava config file path: $lava_config_folder"
```
```
mkdir -p $lavad_home_folder
```
```
mkdir -p $lava_config_folder
``` 
```
cp default_lavad_config_files/* $lava_config_folder
``` 

## 5) Genesis dosyasını indiriyoruz.
  
```
cp genesis_json/genesis.json $lava_config_folder/genesis.json
```
# Cosmovisor Kurulumu
  
> Gelecekteki yükseltmelerin kusursuz bir şekilde gerçekleşmesini sağlamak için cosmovisoru kuruyoruz.
```
go install github.com/cosmos/cosmos-sdk/cosmovisor/cmd/cosmovisor@v1.0.0
```
```
mkdir -p $lavad_home_folder/cosmovisor
```
```
wget https://lava-binary-upgrades.s3.amazonaws.com/testnet/cosmovisor-upgrades/cosmovisor-upgrades.zip
```
```
unzip cosmovisor-upgrades.zip
```
```
cp -r cosmovisor-upgrades/* $lavad_home_folder/cosmovisor
```
> Ortam değişkenlerini güncelliyoruz.
```
echo "# Setup Cosmovisor" >> ~/.profile
echo "export DAEMON_NAME=lavad" >> ~/.profile
echo "export CHAIN_ID=lava-testnet-1" >> ~/.profile
echo "export DAEMON_HOME=$HOME/.lava" >> ~/.profile
echo "export DAEMON_ALLOW_DOWNLOAD_BINARIES=true" >> ~/.profile
echo "export DAEMON_LOG_BUFFER_SIZE=512" >> ~/.profile
echo "export DAEMON_RESTART_AFTER_UPGRADE=true" >> ~/.profile
echo "export UNSAFE_SKIP_BACKUP=true" >> ~/.profile
source ~/.profile
```  
> Ağı Başlatıyoruz.
```
$lavad_home_folder/cosmovisor/genesis/bin/lavad init \
my-node \
--chain-id lava-testnet-1 \
--home $lavad_home_folder \
--overwrite
cp genesis_json/genesis.json $lava_config_folder/genesis.json
```
>  cosmovisor'ın bir hata atacağını unutmayın ⚠️  Bu şekilde bir hata ; /home/ubuntu/.lava/cosmovisor/current/upgrade-info.json: böyle bir dosya veya dizin yok, Sorun yok devam ediyoruz.
  
## Versiyonu kontrol edelim.
```
cosmovisor version
```

