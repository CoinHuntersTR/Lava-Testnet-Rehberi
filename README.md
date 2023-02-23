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
sudo apt install curl git wget htop tmux build-essential jq make lz4 gcc -y
```

## 2) Moniker adımızı ve diğer ayarlarımızı yapıyoruz.
> <YOUR_MONIKER> yerine istediğiniz bir ad yazabilirsiniz <> dahil sili yazıyoruz.
```
LAVA_PORT=20
echo "export WALLET="wallet"" >> $HOME/.bash_profile
echo "export MONIKER="<YOUR_MONIKER>"" >> $HOME/.bash_profile
echo "export LAVA_CHAIN_ID="lava-testnet-1"" >> $HOME/.bash_profile
echo "export LAVA_PORT="${LAVA_PORT}"" >> $HOME/.bash_profile
source $HOME/.bash_profile
```
## 3) Go yüklüyoruz.

```
cd $HOME
VER="1.19.4"
wget "https://golang.org/dl/go$VER.linux-amd64.tar.gz"
sudo tar -C /usr/local -xzf "go$VER.linux-amd64.tar.gz"
rm -rf  "go$VER.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
source $HOME/.bash_profile
go version
```

## 4) Binary ve ayarları yapıyoruz.

```
cd $HOME
rm -rf $HOME/lava
git clone https://github.com/lavanet/lava.git
cd lava
git checkout v0.5.2
make install
```
> Versiyonu kontrol edelim.
```
lavad version --long | grep version
```

## 5) config ve diğer ayarları yapıyoruz.

```
lavad config node tcp://localhost:${LAVA_PORT}657
lavad config keyring-backend test
lavad config chain-id $LAVA_CHAIN_ID
lavad init $MONIKER --chain-id $LAVA_CHAIN_ID
```
## 6) Genesis dosyasını indirip, Addrbook ekliyoruz.

```
curl https://raw.githubusercontent.com/K433QLtr6RA9ExEq/GHFkqmTzpdNLDd6T/main/testnet-1/genesis_json/genesis.json > ~/.lava/config/genesis.json
curl https://files.itrocket.net/testnet/lava/addrbook.json > ~/.lava/config/addrbook.json
```
## 7) Peer ekliyoruz. (Daha hızlı şekilde node sekronize etmek için)

```
SEEDS="3a445bfdbe2d0c8ee82461633aa3af31bc2b4dc0@prod-pnet-seed-node.lavanet.xyz:26656,e593c7a9ca61f5616119d6beb5bd8ef5dd28d62d@prod-pnet-seed-node2.lavanet.xyz:26656"
PEERS=""
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.lava/config/config.toml
```
## 8) app.toml dosyasını ayarlıyoruz.
  
```
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${LAVA_PORT}317\"%;
s%^address = \":8080\"%address = \":${LAVA_PORT}080\"%;
s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${LAVA_PORT}090\"%; 
s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${LAVA_PORT}091\"%; 
s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${LAVA_PORT}545\"%; 
s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${LAVA_PORT}546\"%" $HOME/.lava/config/app.toml
```
## 9) config.tom dosyasını ayarlıyoruz.
  
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${LAVA_PORT}658\"%; 
s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://0.0.0.0:${LAVA_PORT}657\"%; 
s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${LAVA_PORT}060\"%;
s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${LAVA_PORT}656\"%;
s%^external_address = \"\"%external_address = \"$(wget -qO- eth0.me):${LAVA_PORT}656\"%;
s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${LAVA_PORT}660\"%" $HOME/.lava/config/config.toml
```
## 10) config.tom dosyasını ayarlıyoruz.
  
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${LAVA_PORT}658\"%; 
s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://0.0.0.0:${LAVA_PORT}657\"%; 
s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${LAVA_PORT}060\"%;
s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${LAVA_PORT}656\"%;
s%^external_address = \"\"%external_address = \"$(wget -qO- eth0.me):${LAVA_PORT}656\"%;
s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${LAVA_PORT}660\"%" $HOME/.lava/config/config.toml
```
