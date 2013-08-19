#!/usr/bin/env bash

# Update all packages
echo "Updating the Virtual Machine..."
sudo apt-get -y update &> /dev/null
sudo apt-get upgrade -y &> /dev/null

# Install dependancies necessary for compiling tmwa
echo "Installing TMWA dependancies..."
sudo apt-get -y install build-essential flex bison git &> /dev/null

# Set up sharing the folder with the host OS
echo "Setting up folder sharing for content..."
ln -fs /vagrant/ /home/vagrant/tmwAthena &> /dev/null

# Set up tmwa and tmwa-server-data repositories and compile tmwa
if [ -d "/root/tmwAthena/tmwa" ]; then
  echo "Updating tmwa and server data..."
  cd /home/vagrant/tmwAthena/tmwa
  git pull 
  echo "Rebuilding tmwa (please be patient, this can take a while)..."
  git submodule update --init
  ./configure &> /dev/null
  make &> /dev/null
  sudo make install &> /dev/null
  cd ../tmwa-server-data
  git pull
else
  echo "Cloning tmwa and server data..."
  cd /home/vagrant/tmwAthena
  git clone --recursive git://github.com/themanaworld/tmwa.git
  git clone --recursive git://github.com/themanaworld/tmwa-server-data.git
  cd tmwa
  git submodule update --init
  echo "Building TMWA (please be patient, this can take a while)..."
  ./configure &> /dev/null
  make &> /dev/null
  sudo make install &> /dev/null
  git config --global url.git@github.com:.pushInsteadOf git://github.com
  cd ../tmwa-server-data
  echo "Setting up update hooks..."
  ln -s ../../git/hooks/post-merge .git/hooks/
  ln -s ../../../../git/hooks/post-merge .git/modules/client-data/hooks/
  echo "Creating the configuration files..."
  make conf
  # Checkout master branches inside client-data
  cd client-data
  git checkout master
  cd music
  git checkout master
fi

# Run the tmwa server
cd /home/vagrant/tmwAthena/tmwa-server-data/
echo "Starting the server..."
./char-server& ./login-server& ./map-server&
sleep 20
echo "Server is now running. You can reach it by adding a new server to your client:"
echo "Name: Local Server"
echo "Address: localhost"
echo "Port: 6901"
echo "Server type: TmwAthena"
echo "Have fun!"