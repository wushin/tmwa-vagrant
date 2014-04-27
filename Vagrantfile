# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "wushin/tmw-vagrant"
  config.vm.box_url = "https://vagrantcloud.com/wushin/tmw-vagrant/version/1/provider/virtualbox.box"
  config.vm.box_check_update = "true"
  config.vm.box_download_checksum = "0b5271ba5d4e02227f36726886245996eb48ece2"
  config.vm.box_download_checksum_type = "sha1"

  # Set up a hostname for the machine
  config.vm.hostname = "tmw-vagrant"

  # Forward ports for the character, map and login server
  config.vm.network :forwarded_port, guest: 6122, host: 6122
  config.vm.network :forwarded_port, guest: 5122, host: 5122
  config.vm.network :forwarded_port, guest: 6901, host: 6901

  # Provision the VM
  $script = <<SCRIPT
chmod u+x /vagrant/bootstrap.sh
su vagrant -c /vagrant/bootrap.sh
SCRIPT
  config.vm.provision :shell, :path => "./bootstrap.sh"
end
