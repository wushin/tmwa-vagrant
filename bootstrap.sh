#!/usr/bin/env bash
# VM has self contained updater & build bot
sudo cp /vagrant/tmwa-init /etc/init.d/tmwa-init
sudo chown vagrant:vagrant /etc/init.d/tmwa-init
/etc/init.d/tmwa-init install
