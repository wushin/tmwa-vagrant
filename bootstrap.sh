#!/usr/bin/env bash
# VM has self contained updater & build bot
sudo install -m755 -o vagrant -g vagrant -t /etc/init.d /vagrant/tmwa-init
/etc/init.d/tmwa-init install
