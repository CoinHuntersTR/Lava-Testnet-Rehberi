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
## 10) config.toml dosyasını ayarlıyoruz.
  
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${LAVA_PORT}658\"%; 
s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://0.0.0.0:${LAVA_PORT}657\"%; 
s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${LAVA_PORT}060\"%;
s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${LAVA_PORT}656\"%;
s%^external_address = \"\"%external_address = \"$(wget -qO- eth0.me):${LAVA_PORT}656\"%;
s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${LAVA_PORT}660\"%" $HOME/.lava/config/config.toml
```
## 11) Config yapılandırmasına devam ediyoruz.
  
```
sed -i -e "s/^pruning *=.*/pruning = \"nothing\"/" $HOME/.lava/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/" $HOME/.lava/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"50\"/" $HOME/.lava/config/app.toml
```

## 12) Gas ödemesini yeniden ayarlıyoruz.
  
```
sed -i 's/minimum-gas-prices =.*/minimum-gas-prices = "0.0ulava"/g' $HOME/.lava/config/app.toml
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.lava/config/config.toml
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.lava/config/config.toml
```
## 13) Parametreleri güncelliyoruz.
  
```
sed -i 's/create_empty_blocks = .*/create_empty_blocks = true/g' ~/.lava/config/config.toml
sed -i 's/create_empty_blocks_interval = ".*s"/create_empty_blocks_interval = "60s"/g' ~/.lava/config/config.toml
sed -i 's/timeout_propose = ".*s"/timeout_propose = "60s"/g' ~/.lava/config/config.toml
sed -i 's/timeout_commit = ".*s"/timeout_commit = "60s"/g' ~/.lava/config/config.toml
sed -i 's/timeout_broadcast_tx_commit = ".*s"/timeout_broadcast_tx_commit = "601s"/g' ~/.lava/config/config.toml
```
## 14) Parametreleri güncelliyoruz.
  
```
sed -i 's/create_empty_blocks = .*/create_empty_blocks = true/g' ~/.lava/config/config.toml
sed -i 's/create_empty_blocks_interval = ".*s"/create_empty_blocks_interval = "60s"/g' ~/.lava/config/config.toml
sed -i 's/timeout_propose = ".*s"/timeout_propose = "60s"/g' ~/.lava/config/config.toml
sed -i 's/timeout_commit = ".*s"/timeout_commit = "60s"/g' ~/.lava/config/config.toml
sed -i 's/timeout_broadcast_tx_commit = ".*s"/timeout_broadcast_tx_commit = "601s"/g' ~/.lava/config/config.toml
```
## 15) Chain verilerini sıfırlıyoruz.
  
```
lavad tendermint unsafe-reset-all --home $HOME/.lava
```
## 16) Servis doysasını oluşturuyoruz.
  
```
sudo tee /etc/systemd/system/lavad.service > /dev/null <<EOF
[Unit]
Description=lava
After=network-online.target

[Service]
User=$USER
ExecStart=$(which lavad) start --home $HOME/.lava
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```
## 17) Node etkinleştirip çalıştırıyoruz.
  
```
sudo systemctl daemon-reload
```
```
sudo systemctl enable lavad
```
```
 sudo systemctl restart lavad && sudo journalctl -u lavad -f
```
> Burada ağ başladıktan sonra exit code hatası veya bağlanma hatası alıyorsanız. Aşağıdan devam edebilirsiniz. Ctrl+C ile durdurup devam ediyoruz.

## 18) Snapshot indiriyoruz.
  
```
sudo systemctl stop lavad
cp $HOME/.lava/data/priv_validator_state.json $HOME/.lava/priv_validator_state.json.backup
rm -rf $HOME/.lava/data
curl https://files.itrocket.net/testnet/lava/snap_lava.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.lava
mv $HOME/.lava/priv_validator_state.json.backup $HOME/.lava/data/priv_validator_state.json
```
## 18) Node tekrar başlatıyoruz.
  
```
sudo systemctl restart lavad && sudo journalctl -u lavad -f
```
# 82570. bloktan sonra güncelleme yapılması gerekiyor. Onu yapıyoruz.
  
## 20) Node tekrar başlatıyoruz.
  
```
sudo systemctl stop lavad

cd $HOME
rm -rf $HOME/lava
git clone https://github.com/lavanet/lava.git
cd lava
git checkout v0.6.0-RC3
make install

sudo systemctl start lavad
sudo journalctl -u lavad -f --no-hostname -o cat
``` 
## Node Durumu Görüntüleme
>  Bu işlemler sonrasında Ctrl +C ile devam ediyoruz. Sonrasında node sekronize olması gerekiyor. aşağıdaki kodu girdiğinizde
```
lavad status 2>&1 | jq .SyncInfo
``` 
![false](https://user-images.githubusercontent.com/111747226/220988248-52e8d197-2894-4cb2-bf98-f22a9fd1e3bb.png)
  
 
Bu şekilde false alıyorsanız. İşlem tamamdır. True olarak geliyorsa senkronize olmamaış demektir. Validator kurulabilmek için senkronize olması gerekiyor. 

# Validator Kurulumu
## 1) Cüzdan oluşturma
>   cüzdanadi yerine istediğiniz bir ismi yazabilirsiniz.
```
lavad keys add cüzdanadi
```
> bu komut sonrasında aşağıdakine benzer bir çıktı alıyoruz. Çıktıda siyah olarak karaladığım alan gizli anahtar kelimeler, onları bir yere kayıt etmeyi unutmayın.
![cuzdan](https://user-images.githubusercontent.com/111747226/220991001-b7e24e96-4728-4ad2-9e59-f91a7150064f.png)
  
lava@15tmnshwnsu5r4j9376dhydrukpf6avatlqgy9e buna benzer bir cüzdan adresiniz oluyor. şimdi faucetten token istiyoruz.

### <a href="https://discord.gg/lavanetxyz" target="_blank" rel="Lava Network" >Buradan</a> discorda kanallarına katılıyoruz. Faucet kanalına gidiyoruz.
  ```
$request cüzdanadresi
```
## 2) Validator Oluşturma
>   cüzdanadi yerine kendi cüzdanadınızı yazın. komutu yazdıktan sonra, gelen soruya y ENTER diyoruz.
```
lavad tx staking create-validator \
  --amount 9000ulava \
  --from cüzdanadadi \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.05" \
  --min-self-delegation "1" \
  --pubkey  $(lavad tendermint show-validator) \
  --moniker $MONIKER \
  --chain-id $LAVA_CHAIN_ID
```
## 2) Validator takibi
  > Validator oluştruduktan sonra size bir TXH verecek bunu;
  
  <a href="https://lava.explorers.guru/" target="_blank" rel="Lava Network" >Lava Explorer</a> adresine gidiyoruz. Terminalde verilen txh aratıyoruz. "Success" çıktısı aldıysanız node kurulmuş demektir. 
 
  ![explorer](https://user-images.githubusercontent.com/111747226/220993747-0c66945f-5fb8-4db3-9e12-d37904405d7d.png)
  
  Belirlediğiniz Moniker adınız ile ararsannız bu şekilde bir sayfadan node durumunu kontrol edebilirsiniz.
  
# Yararlı Komutlar
  
## Servis Komutları
  
### Log kontrolü

```
sudo journalctl -u lavad -f
```
### Node Durdurma

```
sudo systemctl stop lavad
```
### Node Restart etme

```
sudo systemctl restart lavad
```
### Node Restart etme

```
sudo systemctl restart lavad
```

## Cüzdan Komutları
  
### Cüzdan bakiye kontrolü

```
lavad query bank balances cüzdanadresi
```
### Cüzdan token transferi

```
lavad tx bank send kendicüzdanadresin gidecekcüzdanadresi 1000000ulava --gas auto --gas-adjustment 1.3
```
### Cüzdan listeleme

```
lavad keys list
```
### Yeni cüzdan oluşturma

```
lavad keys add cüzdanadı
```
### Var olan cüzdanı yeniden yükleme

```
lavad keys add cüzdanadi --recover
```
### Cüzdan Silme
```
lavad keys delete $WALLET
```
### Cüzdan Silme
```
lavad keys delete $WALLET
```
## Node Bilgilerine erişim
  
### Node senkronizasyon

```
lavad status 2>&1 | jq .SyncInfo
```
### Node durumu

```
curl -s localhost:${LAVA_PORT}657/status
```
### Oylamaya Katılma

```
lavad tx gov vote (oylama numarası) yes --from cüzdanadi --chain-id $LAVA_CHAIN_ID
```
### Ödülleri cüzdana çekme

```
lavad tx distribution withdraw-all-rewards --from cüzdanadi --chain-id $LAVA_CHAIN_ID --gas auto --gas-adjustment 1.3
```
### Komisyon ödüllerini çekme

```
lavad tx distribution withdraw-rewards $VALOPER_ADDRESS --from $WALLET --commission --chain-id $LAVA_CHAIN_ID --gas auto --gas-adjustment 1.3
```
### Delegate etme

```
lavad tx staking delegate $VALOPER_ADDRESS 1000000ulava --from $WALLET --chain-id $LAVA_CHAIN_ID --gas=auto --gas-adjustment 1.3
```
### Başka Validatordan Redelegate etme

```
lavad tx staking redelegate kendivalidatoradresin karsivalidatoradresi 1000000ulava --from $WALLET --chain-id $LAVA_CHAIN_ID --gas auto --gas-adjustment 1.3
```


