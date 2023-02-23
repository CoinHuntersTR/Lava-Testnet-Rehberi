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
