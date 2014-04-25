#!/usr/bin/env bash
# VM has self contained updater & build bot
cp /vagrant/tmwa-init /etc/init.d/tmwa-init
/etc/init.d/tmwa-init install
