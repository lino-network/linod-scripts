#!/usr/bin/env bash

# install snappy & cleveldb
sudo apt-get update
sudo apt-get install -y build-essential

sudo apt-get install -y libsnappy-dev
homedir="$PWD"

wget https://github.com/google/leveldb/archive/v1.20.tar.gz && \
  tar -zxvf v1.20.tar.gz && \
  cd leveldb-1.20/ && \
  make && \
  sudo cp -r out-static/lib* out-shared/lib* /usr/local/lib/ && \
  cd include/ && \
  sudo cp -r leveldb /usr/local/include/ && \
  sudo ldconfig && \
  rm -f v1.20.tar.gz

cd "$homedir"

# load go
source .profile
sudo ldconfig
go version

# get lino core code
mkdir go
cd go
mkdir -p src/github.com/lino-network
cd src/github.com/lino-network
git clone https://github.com/lino-network/lino.git
cd lino
git checkout v0.1.5

# golang dep
go get -u github.com/golang/dep/cmd/dep
dep ensure

# replace customize file
cp /vagrant/codes/http_server ./vendor/github.com/tendermint/tendermint/rpc/lib/server/http_server.go
cp /vagrant/codes/iavlstore ./vendor/github.com/cosmos/cosmos-sdk/store/iavlstore.go
cp /vagrant/codes/baseapp ./vendor/github.com/cosmos/cosmos-sdk/baseapp/baseapp.go

mkdir build
cd build
cp /vagrant/codes/genesis.json genesis.json
cp /vagrant/codes/config.toml config.toml
CGO_LDFLAGS="-lsnappy" CGO_ENABLED=1 go build -ldflags "-X github.com/tendermint/tendermint/version.GitCommit=`git rev-parse --short=8 HEAD`" -tags "tendermint gcc" ../cmd/lino

echo "linod build with cleveldb finished, you need to run 'lino init' and then update config.toml"
echo "config.toml: db_backend --> cleveldb, moniker --> some random identifier"
