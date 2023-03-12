#!/bin/bash
exists()
{
  command -v "$1" >/dev/null 2>&1
}

RED="\e[31m"
GREEN="\e[32m"
ENDCOLOR="\e[0m"

function NodePreInstall () {

  echo "---------------------------------------------------"
  echo -e "${GREEN}Validator kurulumu"${ENDCOLOR} && sleep 2

  cd $HOME
  wget -qO $HOME/lavad https://github.com/lavanet/lava/releases/download/v0.7.0/lavad-v0.7.0-RC1-linux-amd64
  chmod +x $HOME/lavad
  sudo mv $HOME/lavad $(which lavad)
  lavad version & sleep 2
  echo -e " "

}

function NodeInitialize () {

  source $HOME/.bash_profile

  echo "---------------------------------------------------"
  echo -e "${GREEN}Başlatma ve kurulum: "${ENDCOLOR} && sleep 2

  lavad init $LAVA_NODENAME --chain-id $LAVA_CHAIN_ID && sleep 2

  source $HOME/.bash_profile

  curl -s https://raw.githubusercontent.com/K433QLtr6RA9ExEq/GHFkqmTzpdNLDd6T/main/testnet-1/genesis_json/genesis.json > $HOME/.lava/config/genesis.json

  sed -i 's|^minimum-gas-prices *=.*|minimum-gas-prices = "0.025ulava"|g' $HOME/.lava/config/app.toml

  PRUNING_INTERVAL=$(shuf -n1 -e 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97)
  sed -i 's|^pruning *=.*|pruning = "custom"|g' $HOME/.lava/config/app.toml
  sed -i 's|^pruning-keep-recent  *=.*|pruning-keep-recent = "100"|g' $HOME/.lava/config/app.toml
  sed -i 's|^pruning-interval *=.*|pruning-interval = "'$PRUNING_INTERVAL'"|g' $HOME/.lava/config/app.toml
  sed -i 's|^snapshot-interval *=.*|snapshot-interval = 2000|g' $HOME/.lava/config/app.toml

  SEEDS="3a445bfdbe2d0c8ee82461633aa3af31bc2b4dc0@prod-pnet-seed-node.lavanet.xyz:26656,e593c7a9ca61f5616119d6beb5bd8ef5dd28d62d@prod-pnet-seed-node2.lavanet.xyz:26656"
  sed -i 's|^seeds *=.*|seeds = "'$SEEDS'"|' $HOME/.lava/config/config.toml

}

function NodePeers () {  
  PEERS="37fc77cca6c945d12c6e54166c3b9be2802ad1e6@lava-testnet.nodejumper.io:27656,4bfb0d4d945985d2cc92ea4ba3578459b80f1dab@190.2.155.67:33656,ac7cefeff026e1c616035a49f3b00c78da63c2e9@18.215.128.248:26656,6c988ad39fef48abd5504fda547d561fb8a60c3a@130.185.119.243:33656,2c2353c872b0c5af562c518b1aa48a2649a4c927@65.108.199.62:11656,4f9120f706512162fbe4f39aac78b9924efbec58@65.109.92.235:11036,f9190a58670c07f8202abfd9b5b14187b18d755b@144.76.97.251:27656,f120685de6785d8ee0eadfca42407c6e10593e74@144.76.90.130:32656,6641a193a7004447c1b49b8ffb37a90682ce0fb9@65.108.78.116:13656,c19965fe8a1ea3391d61d09cf589bca0781d29fd@162.19.217.52:26656,0516c4d11552b334a683bdb4410fa22ef7e3f8ba@65.21.239.60:11656,dabe2e77bd6b9278f484b34956750e9470527ef7@178.18.246.118:26656,24a2bb2d06343b0f74ed0a6dc1d409ce0d996451@188.40.98.169:27656,b7c3cedc778d93296f179373c3bc6a521e4b682e@65.109.69.160:30656,c678ae0fd7b754615e55bba2589a86e60fc8d45c@136.243.88.91:7140,a65de5f01394199366c182a18d718c9e3ef7f981@159.148.146.132:26656,cc2b2250b21cd6d23305143a32181e5f6bfc5956@135.181.50.187:26656,0561fed6e88f2167979e379436529861527d859d@65.109.92.148:61256,2b5d760125c90970ce27f4783a5d70a19534ff61@146.19.24.101:26546,3c47fd1662bcb17a4713c23e41d7b25e34478b8e@103.19.25.157:26672,131227f65bbc8f5b86030124fa1610a3283ebcbd@135.181.176.109:26656,72aabf4950afe5f2514cff8dc6c2c56600e7ed03@34.251.254.15:26656,5a469a75fb05eddf2d79fb17063cc59e84d0821a@207.180.236.115:34656,0314d53cc790860fb51f36ac656a19789800ce5c@176.103.222.20:26656,14ae45e7f2ff7491cfa686a8fcac7cc095bc38ff@213.239.217.52:39656,28db9a9c200bedbe5d322f7571462f1146ef898e@209.126.2.184:26656,de764d94d3eed3ac15c2151b5576dd24de5bec81@38.242.236.179:26656,57474bd0977b3ed65cf23086b6d1d92bf00d50d0@207.180.236.122:31656,0efa60456219f5b7847ee21439aa8662c0a8e1b6@65.21.195.40:26656,f22ea1e7b6d31966259e99177d714cffde27c4bf@152.32.211.182:26656,024a0b0a6eae16a2e8aaefcf26b12d2a3b393b28@75.119.155.60:26656,2db2e00432fc950fa2afa03a84288a437fc1c305@2.58.82.212:26656,9a8477637f7944f2537234bbfb6e1559b7805157@195.3.221.13:56656,0a528da95ca8025ef4043b6e73f1e789f4102940@176.103.222.22:26656,90451ff8f47b8f4b077e95837f112135fea14531@207.180.231.123:31656,529675163b5d16838928fe10edce5ef827ff591f@46.4.68.113:25556,f80ab02da4448f7c2dfa450fb2f1501bd1a4f2af@109.123.241.78:26656,daa11ae80a2fecde611054b6ca83453462878d9e@65.108.65.246:30656,464e98fa27165f3a13f4173c0ecfbe71ce8f1bf2@167.86.94.71:36656,897fbd850aff33b4d5012d30a8b0ce04225f907f@2.58.82.231:26656,c80f5f3b6828342ed2c38026eede1f59b466d30f@168.119.124.130:47656,151cc6fb6d1a4a4c2f76f7eaf43b9ea80d62ec7b@95.214.55.46:22626,6b1d0465b3e2a32b5328e59eb75c38d88233b56f@80.82.215.19:60656,d3001223151430f204917eb87f86d0bd1e795ebf@161.97.162.6:26656,41394b7c876d2426969c6f10a3400d7c57271130@38.242.253.207:26656,c210ed8ecd986a7cc19e87a34c5a2a0f87f1a45c@185.48.24.106:29656,3b3a633e4ad83914a64288dca82f7a7b62536820@65.21.193.112:38656,a76af03d79a90992d135750ab945f79f167d6ee4@65.109.139.182:26656,3a445bfdbe2d0c8ee82461633aa3af31bc2b4dc0@3.252.219.158:26656,b05202b1a7475141f37ef705f936470299189da3@109.111.160.171:27656,2031e65ee8a13e57d922a14d28d67be0ada21a95@54.194.240.43:26656"
  sed -i 's|^persistent_peers *=.*|persistent_peers = "'$PEERS'"|' $HOME/.lava/config/config.toml
}

function NodeServiceFile () {

  echo "---------------------------------------------------"
  echo -e "${GREEN}Servis dosyası kurulumu${ENDCOLOR}" && sleep 2

  echo "
  [Unit]
  Description=Lava Node
  After=network-online.target

  [Service]
  User=$USER
  Type=simple
  ExecStart=$(which lavad) start
  Restart=on-failure
  RestartSec=3
  LimitNOFILE=65535

  [Install]
  WantedBy=multi-user.target" > $HOME/lavad.service
  sudo mv $HOME/lavad.service /etc/systemd/system  

}

function NodeSnapshot () {

  echo "---------------------------------------------------"
  echo -e "${GREEN}Anlık görüntü yükleme${ENDCOLOR}" && sleep 2

  sudo systemctl stop lavad

  cp $HOME/.lava/data/priv_validator_state.json $HOME/.lava/priv_validator_state.json.backup
  lavad tendermint unsafe-reset-all --home $HOME/.lava --keep-addr-book

  SNAP_NAME=$(curl -s https://snapshots1-testnet.nodejumper.io/lava-testnet/ | egrep -o ">lava-testnet-1.*\.tar.lz4" | tr -d ">")
  curl https://snapshots1-testnet.nodejumper.io/lava-testnet/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/.lava

  mv $HOME/.lava/priv_validator_state.json.backup $HOME/.lava/data/priv_validator_state.json

}

function NodeChangePorts () {

  echo "---------------------------------------------------"
  echo -e "${GREEN}Port değiştirmek gerekli mi? İstediğiniz eylemi seçin ve tıklayın Enter${ENDCOLOR}" && sleep 3
  echo -e ""
  echo "1 Evet, varsayılan validator bağlantı noktalarını değiştir (Daha - https://wenmoney.io/cheat-sheet-cosmos-nodes#Ozd0)"
  echo "2 HAYIR, varsayılan bağlantı noktalarını bırak"

  read ports

  case $ports in 
    1)

      source $HOME/.bash_profile

      if [ ! $LAVA_gRPC ]; then
        read -p "gRPC bağlantı noktasını girin : " LAVA_gRPC
        echo 'export LAVA_gRPC='\"${LAVA_gRPC}\" >> $HOME/.bash_profile
      else
        echo -e "LAVA_gRPC bağlantı noktası sistemde zaten yüklü"
      fi

      if [ ! $LAVA_gRPCweb ]; then
        read -p "gRPC(web) bağlantı noktasını girin: " LAVA_gRPCweb
        echo 'export LAVA_gRPCweb='\"${LAVA_gRPCweb}\" >> $HOME/.bash_profile
      else
        echo -e "LAVA_gRPCweb bağlantı noktası sistemde zaten yüklü"
      fi

      if [ ! $LAVA_proxy_app ]; then
        read -p "Bağlantı Noktasını Girin proxy_app: " LAVA_proxy_app
        echo 'export LAVA_proxy_app='\"${LAVA_proxy_app}\" >> $HOME/.bash_profile
      else
        echo -e "LAVA_proxy_app bağlantı noktası sistemde zaten yüklü"
      fi

      if [ ! $LAVA_laddrrpc ]; then
        read -p "Laddr(rpc) bağlantı noktasını girin: " LAVA_laddrrpc
        echo 'export LAVA_laddrrpc='\"${LAVA_laddrrpc}\" >> $HOME/.bash_profile
      else
        echo -e "LAVA_laddrrpc bağlantı noktası sistemde zaten yüklü"
      fi

      if [ ! $LAVA_pprof_laddr ]; then
        read -p "pprof_laddr bağlantı noktasını girin: " LAVA_pprof_laddr
        echo 'export LAVA_pprof_laddr='\"${LAVA_pprof_laddr}\" >> $HOME/.bash_profile
      else
        echo -e "LAVA_pprof_laddr bağlantı noktası sistemde zaten yüklü"
      fi

      if [ ! $LAVA_laddrp2p2 ]; then
        read -p "port laddr(p2p) girin: " LAVA_laddrp2p2
        echo 'export LAVA_laddrp2p2='\"${LAVA_laddrp2p2}\" >> $HOME/.bash_profile
      else
        echo -e "LAVA_laddrp2p2 bağlantı noktası sistemde zaten yüklü"
      fi

      if [ ! $LAVA_prometheus ]; then
        read -p "Bağlantı Noktasını Girin prometheus: " LAVA_prometheus
        echo 'export LAVA_prometheus='\"${LAVA_prometheus}\" >> $HOME/.bash_profile
      else
        echo -e "LAVA_prometheus bağlantı noktası sistemde zaten yüklü"
      fi

      if [ ! $LAVA_api ]; then
        read -p "Bağlantı Noktasını Girin api: " LAVA_api
        echo 'export LAVA_api='\"${LAVA_api}\" >> $HOME/.bash_profile
      else
        echo -e "LAVA_api bağlantı noktası sistemde zaten yüklü"
      fi
      echo -e ""

      source $HOME/.bash_profile
      sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${LAVA_proxy_app}\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${LAVA_laddrrpc}\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${LAVA_laddrp2p2}\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${LAVA_pprof_laddr}\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${LAVA_prometheus}\"%" $HOME/.lava/config/config.toml && sed -i.bak -e "s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${LAVA_gRPC}\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${LAVA_gRPCweb}\"%; s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${LAVA_api}\"%" $HOME/.lava/config/app.toml && sed -i.bak -e "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:${LAVA_laddrrpc}\"%" $HOME/.lava/config/client.toml

      echo -e "Bağlantı noktası değişikliği ${GREEN}tamamlandı${ENDCOLOR}! Sonuç şuraya kaydedilir: .bash_profile" && sleep 2

    ;;
    2)
      echo -e "Bağlantı noktası ${RED}değiştirilmedi${ENDCOLOR}!" && sleep 2
    ;;
  *)
  echo "Geçersiz işlem girildi"
  esac

}

function NodeRestart () {

  echo "---------------------------------------------------"
  echo -e "${GREEN}Düğüm başlatma${ENDCOLOR}" && sleep 2

  sudo systemctl daemon-reload
  sudo systemctl enable lavad
  sudo systemctl restart lavad
}

function NodeCheck () {

  echo "---------------------------------------------------"
  echo -e "${GREEN}Düğüm durumu kontrol ediliyor${ENDCOLOR}" && sleep 2

  if [[ `service lavad status | grep active` =~ "running" ]]; then
    echo -e "Düğümünüz ${GREEN}yüklü ve çalışıyor${ENDCOLOR}!"
    echo -e ""
    echo -e "Logları komut ile kontrol edebilirsiniz.${GREEN}journalctl -u lavad -f -o cat${ENDCOLOR}"
    echo -e ""
  else
    echo -e "Düğümünüz ${RED}yanlış yüklenmiş${ENDCOLOR}, yeniden yükleyin."
  fi     
}

function NodeWalletSetup {
  echo "---------------------------------------------------"
  echo -e "${GREEN}Cüzdan kurulumu${ENDCOLOR}" && sleep 2

  echo -e "Bir eylem seçin ve istediğiniz sayıyı gi" && sleep 3
  echo -e ""
  echo "1 Yeni bir cüzdan oluşturm"
  echo "2 Cüzdan Kurtarma"

  read doing

  case $doing in 
    1) 
    read -p "Cüzdan adını girin: " wallet
    echo "export LAVA_WALLET=$wallet" >> $HOME/.bash_profile
    echo -e "Cüzdan kurulumu..." && sleep 2
    source $HOME/.bash_profile
    lavad keys add $LAVA_WALLET --keyring-backend os
    echo "Hatırlatıcı cümleyi cüzdanınızdan kaydetmeyi unutma"
    echo -e ""
    ;;
    2)
    if [ ! $LAVA_WALLET ]; then
      read -p "Cüzdan adınızı girin: " wallet
      echo "export LAVA_WALLET=$wallet" >> $HOME/.bash_profile
      source $HOME/.bash_profile
      echo -e ""
    fi
    echo -e "Cüzdan kurtarma - sonraki adımda, tohum ifadesini ekleyin" && sleep 2
    lavad keys add $LAVA_WALLET --recover --keyring-backend os
    echo -e ""
    ;;
  *)
  echo "Geçersiz işlem girildi"
  esac

  if [ ! $LAVA_ADDRESS ]; then
    echo "---------------------------------------------------"
    echo -e "${GREEN}ADRES ve VALOPER ekleme (çift ​​şifre istemi olacak)${ENDCOLOR}" && sleep 2

    source $HOME/.bash_profile
    LAVA_ADDRESS=$(lavad keys show $LAVA_WALLET -a --keyring-backend os)
    LAVA_VALOPER=$(lavad keys show $LAVA_WALLET --bech val -a --keyring-backend os)
    echo 'export LAVA_ADDRESS='${LAVA_ADDRESS} >> $HOME/.bash_profile
    echo 'export LAVA_VALOPER='${LAVA_VALOPER} >> $HOME/.bash_profile
    source $HOME/.bash_profile
  fi
}

function NodeStop () {
  echo "---------------------------------------------------"
  echo -e "${GREEN}Düğüm durağı${ENDCOLOR}" && sleep 2

  sudo systemctl stop lavad
}

function NodeBackupKey () {
  cp .lava/config/priv_validator_key.json $HOME/priv_validator_state.json.backup.lava
}

function NodeDelete () {

  echo "---------------------------------------------------"
  echo -e "${GREEN}Bir düğümü si${ENDCOLOR}" && sleep 2

  systemctl disable lavad
  rm /etc/systemd/system/lavad.service
  systemctl daemon-reload
  cd $HOME
  rm -rf .lava GHFkqmTzpdNLDd6T
  rm -rf $(which lavad)

}

function NodeUpdate070 () {

  echo "---------------------------------------------------"
  echo -e "${GREEN}Düğüm güncellem${ENDCOLOR}" && sleep 2

  rm -rf lava
  wget -qO $HOME/lavad https://github.com/lavanet/lava/releases/download/v0.7.0/lavad-v0.7.0-RC1-linux-amd64
  chmod +x $HOME/lavad
  sudo mv $HOME/lavad $(which lavad)
  lavad version & sleep 2
  echo -e " "
}


# MAIN SCRIPT BEGIN

echo "---------------------------------------------------"
echo -e "${GREEN}Başlatma ${ENDCOLOR}" && sleep 2

sudo apt install curl -y
curl -s https://raw.githubusercontent.com/CoinHuntersTR/Andromeda-Testnet-Rehberi/main/logo.sh | bash

echo "---------------------------------------------------"
echo -e "${GREEN}Bir eylem seçin. İstenilen numarayı girin ve tuşu ile işlemi onaylayın. Enter${ENDCOLOR}" && sleep 3
echo -e ""
echo "1 Düğümü sıfırdan kurun (lava-testnet-1) - yerleşik anlık görüntü, bağlantı noktası değişikliği mevcut"
echo "2 102.800 bloğunda 0.7.0 sürümüne güncelleme"
echo "3 Parametre ayarı"
echo "4 Belleği temizleyin ve anlık görüntüden yükleyin (doğrulayıcı ve cüzdan verilerine dokunulmaz)"
echo "5 Cüzdan ekle veya geri yükle"
echo "6 Düğümü sil (doğrulayıcı anahtar, .backup uzantılı .root'a kaydedilecek)"

read doing

case $doing in 
  1)
    echo "---------------------------------------------------"
    echo -e "${GREEN}Paketleri yükleme: "${ENDCOLOR} && sleep 2

    sudo apt update && sudo apt upgrade -y 
    sudo apt install build-essential pkg-config libssl-dev git jq wget make gcc nano htop net-tools screen lz4 -y < "/dev/null"

    if [ ! -f "/usr/local/go/bin/go" ]; then
      wget -q -O go_install.sh https://nodes.wenmoney.io/go_install.sh && chmod +x go_install.sh && ./go_install.sh
    fi

    NodePreInstall

    if [ ! $LAVA_NODENAME ]; then
      read -p "Lav düğümünün adını girin: " LAVA_NODENAME
      echo 'export LAVA_NODENAME='\"${LAVA_NODENAME}\" >> $HOME/.bash_profile
      echo "export LAVA_CHAIN_ID=lava-testnet-1" >> $HOME/.bash_profile
      source $HOME/.bash_profile
    fi

    NodeInitialize
    NodePeers
    NodeServiceFile
    NodeSnapshot
    NodeChangePorts
    NodeRestart
    NodeCheck

    echo "---------------------------------------------------"
    echo -e "${GREEN}Bundan sonra ne yapacağız - günlükleri kontrol edin, her şey yolundaysa, ardından senkronizasyonu bekleyin ve doğrulayıcıyı yükleyin${ENDCOLOR}"
    echo "---------------------------------------------------"
  ;;
  2)
    NodeStop
    NodeUpdate070
    NodeRestart
    NodeCheck
  ;;
  3)
    NodeStop
    sed -i 's/create_empty_blocks = .*/create_empty_blocks = true/g' ~/.lava/config/config.toml
    sed -i 's/create_empty_blocks_interval = ".*s"/create_empty_blocks_interval = "60s"/g' ~/.lava/config/config.toml
    sed -i 's/timeout_propose = ".*s"/timeout_propose = "60s"/g' ~/.lava/config/config.toml
    sed -i 's/timeout_commit = ".*s"/timeout_commit = "60s"/g' ~/.lava/config/config.toml
    sed -i 's/timeout_broadcast_tx_commit = ".*s"/timeout_broadcast_tx_commit = "601s"/g' ~/.lava/config/config.toml
    NodeRestart
    NodeCheck
  ;;
  4)
    NodeStop
    NodeSnapshot
    NodeRestart
    NodeCheck
  ;;
  5)
    NodeWalletSetup
  ;;
  6)
    NodeStop
    NodeBackupKey
    NodeDelete 
  ;;
  *)
echo "Geçersiz işlem girildi. Komut dosyası tamamlandı. Komut dosyasını tekrar çalıştırın ve doğru eylemi seçin!"
esac
