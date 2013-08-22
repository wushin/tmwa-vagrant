# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "precise32"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"
  
  # Set up a hostname for the machine
  config.vm.hostname = "tmw-dev"

  # Forward ports for the character, map and login server
  config.vm.network :forwarded_port, guest: 6122, host: 6122
  config.vm.network :forwarded_port, guest: 5122, host: 5122
  config.vm.network :forwarded_port, guest: 6901, host: 6901

  # Provision the VM
  $script = <<SCRIPT
chmod u+x /vagrant/bootstrap.sh
su vagrant -c /vagrant/bootstrap.sh
SCRIPT
  config.vm.provision :shell, :inline => $script
end
