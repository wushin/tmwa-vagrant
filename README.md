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

**Important:** Installing the Windows GitHub app provides you with a Git GUI and Windows PowerShell, as well as SSH, needed for Vagrant to SSH into the VM.

##Warning
Whenever you run `vagrant up`, the VM updates the local repositories (it does a `git pull`), so that you have the latest version of *tmwa* and *tmwa-server-data*. If you are making any local changes, testing content, or anything like that, it's **recommended** that you do it on a different branch. The provisioning script will now always checkout the master branch before updating, leaving the other branches you might've created untouched.

##Usage
To get shell access to the machine, run `vagrant ssh`.
Once at the shell vagrant can issue a number of commands to `/etc/init.d/tmwa-init` `{start|stop|restart|build|update|update_server|update_data|admin_reset|install|status}`
`start|stop|restart|status` All deal with the servers tmwa-{char|login|map}
`build` will build what ever you have checked out in tmwa/
`update` will update both TMWA and TMWA-data to current master repos
`update_server` updates TMWA to current master repo
`update_data` updates TMWA-data to current master repo
`admin_reset` will reset the admin password to vagrant
`install` will update and reinstall everything

Use `vagrant suspend` to pause the machine. The contents of the VM's ram will be written to your hard drive and it won't be using and CPU or RAM while it's paused. To run it again from its paused state, use `vagrant resume`. To turn the machine off, use `vagrant halt`. To run it again, use `vagrant up`.

To destroy the machine completely (you'll still keep the Vagrantfile and any changes you've made to tmwa and/or tmwa-server data) run `vagrant destroy`.

**Important:** Since version 1.3, Vagrant only provisions the machine on first run. But we want the machine to be updated automatically every time we run it, so, to start the machine, use `vagrant up --provision`.

##Development of base image
`vagrant init wushin/tmw-vagrant` will pull just the image used to make the vmimage. That is hosted here.
[Vagrant Cloud](https://vagrantcloud.com/wushin/tmw-vagrant)

##To do
* Fix the output of the provisioning script (formatting, more information)
* General improvments to the script
