#!/bin/bash

### install golang

GOSOURCE=https://dl.google.com/go/go1.11.5.linux-amd64.tar.gz
GOTARGET=/usr/local
GOPATH=\$HOME/go
PROFILE=/home/vagrant/.profile

curl -sSL $GOSOURCE -o /tmp/go.tar.gz
tar -xzf /tmp/go.tar.gz -C $GOTARGET
rm /tmp/go.tar.gz

# apply environment configuration to the user's .profile
printf "\n" >> $PROFILE
printf "# golang configuration\n" >> $PROFILE
printf "export GOROOT=$GOTARGET/go\n" >> $PROFILE
printf "export GOPATH=$GOPATH\n" >> $PROFILE
printf "export PATH=\$PATH:$GOTARGET/go/bin:$GOPATH/bin\n" >> $PROFILE

source .profile
sudo ldconfig
go version
