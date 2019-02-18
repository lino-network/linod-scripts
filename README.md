# linod-scripts
## run fullnode in testnet
```
cd fullnode/vagrant/
./vagrant_up.sh
vagrant ssh
./install_linod.sh
cd go/src/github.com/lino-network/lino/build/
./lino init
# then you have to manually change config.toml file and cp it and genesis file to ~/.lino/config
./lino start
```
