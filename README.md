#A sane(r) development environment for the [tmw](https://github.com/themanaworld) server and server data

tmwa-vagrant is a Vagrantfile and provisioning script to get you started with developing your own content for [The Mana World](http://www.themanaworld.org). It's also an easy way for you to get a local server going, just if you want to fool around with it.

##Installation
1. Clone this repository
2. [Install Vagrant](http://docs.vagrantup.com/v2/installation/index.html)
3. [Install VirtualBox](https://www.virtualbox.org/wiki/Downloads)
4. Navigate into the repository you've cloned and run `vagrant up`
5. Have fun!

##Usage
To get shell access to the machine, run `vagrant ssh`.

Use `vagrant suspend` to pause the machine. The contents of the VM's ram will be written to your hard drive and it won't be using and CPU or RAM while it's paused. To run it again from its paused state, use `vagrant resume`. To turn the machine off, use `vagrant halt`. To run it again, use `vagrant up`.

To destroy the machine completely (you'll still keep the Vagrantfile and any changes you've made to tmwa and/or tmwa-server data) run `vagrant destroy`.

##Warning
The provisioning script isn't fully finished. It's run every time you do `vagrant up`, so there might be issues as it hasn't been configured to intelligently inspect the environment. I'm still working on that part.