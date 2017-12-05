#!/usr/bin/env bash

# by root

# update Ubuntu box
apt-get update

# base build utils and ssl
apt-get -y install build-essential libssl-dev

# Install Crystal

apt-key adv --keyserver keys.gnupg.net --recv-keys 09617FD37CC06B54
echo "deb https://dist.crystal-lang.org/apt crystal main" | sudo tee /etc/apt/sources.list.d/crystal.list
apt-get update && apt-get install crystal

# Install Git

apt-get -y install git

# Install Yarn

curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
apt-get update && apt-get install yarn

# install Heroku CLI

su -l -c 'wget -qO- https://cli-assets.heroku.com/install-ubuntu.sh | sh' vagrant

# install Lucky
# https://luckyframework.org/guides/installing/

su -l -c 'cd /home/vagrant; git clone https://github.com/luckyframework/lucky_cli' vagrant
su -l -c 'cd /home/vagrant/lucky_cli; git checkout v0.7.1' vagrant
su -l -c 'cd /home/vagrant/lucky_cli; crystal deps' vagrant
su -l -c 'cd /home/vagrant/lucky_cli; crystal build src/lucky.cr --release --no-debug' vagrant
cp /home/vagrant/lucky_cli/lucky /usr/local/bin/

su -l -c 'cd /home/vagrant; lucky init app-test' vagrant
su -l -c 'cd /home/vagrant/app-test; ./bin/setup' vagrant
su -l -c 'cd /home/vagrant/app-test; crystal build src/server.cr -o server -s' vagrant

# starts at 8080
su -l -c 'cd /home/vagrant/app-test; ./server' vagrant
