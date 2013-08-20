#A sane(r) development environment for the [tmw](https://github.com/themanaworld) server and server data

##About
tmwa-vagrant is a Vagrantfile and provisioning script to get you started with developing your own content for [The Mana World](http://www.themanaworld.org). It's also an easy way for you to get a local server going, just if you want to fool around with it.

It creates a disposable headless virtual machine (VM), based on Ubuntu Server 12.04 LTS, which automatically clones [tmwa](https://github.com/themanaworld/tmwa) and [tmwa-server-data](https://github.com/themanaworld/tmwa-server-data), sets up the server, adds a GM level 99 account, and runs the server. *tmwa* and *tmwa-server-data* are shared, so you can access them from the host OS -- they will appear in the folder where you've cloned this repository. It also sets up port forwarding, allowing you to connect to the server using your normal client.

You do not need a pre-existing VM image, everything is downloaded automatically.

##Installation
1. [Install Vagrant](http://docs.vagrantup.com/v2/installation/index.html)
2. [Install VirtualBox](https://www.virtualbox.org/wiki/Downloads)
3. **Optional step for Windows users:** Install the [Windows GitHub app](http://windows.github.com/)
4. Clone this repository
5. Navigate into the repository you've cloned and run `vagrant up`
6. Have fun!

**Note:** Installing the Windows GitHub app provides you with a Git GUI and Windows PowerShell, as well as SSH, needed for Vagrant to SSH into the VM.

##Usage
To get shell access to the machine, run `vagrant ssh`.

Use `vagrant suspend` to pause the machine. The contents of the VM's ram will be written to your hard drive and it won't be using and CPU or RAM while it's paused. To run it again from its paused state, use `vagrant resume`. To turn the machine off, use `vagrant halt`. To run it again, use `vagrant up`.

To destroy the machine completely (you'll still keep the Vagrantfile and any changes you've made to tmwa and/or tmwa-server data) run `vagrant destroy`.

##To do
* Fix the output of the provisioning script (formatting, more information)
* General improvments to the script