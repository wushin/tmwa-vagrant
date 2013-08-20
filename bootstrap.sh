#!/usr/bin/env bash

# Update all packages
echo "Updating the Virtual Machine (if this is the first time you're running this machine, it can take some time)..."
sudo apt-get -y update &> /dev/null
sudo apt-get -y upgrade &> /dev/null

# Install dependancies necessary for compiling tmwa
echo "Installing tmwa dependancies:"

DEPS="build-essential flex bison git"

for pkg in $DEPS; do
  PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $pkg|grep "install ok installed")
  if [ "" == "$PKG_OK" ]; then
    echo Installing $pkg...
    sudo apt-get --force-yes --yes install $pkg &> /dev/null
  else
    echo $pkg is already installed. Skipping installation.
  fi
done

# Set up sharing the folder with the host OS
if [ ! -d "/home/vagrant/tmwAthena/" ]; then
  echo Setting up folder sharing for content...
  ln -fs /vagrant/ /home/vagrant/tmwAthena &> /dev/null
else
  echo Folder sharing already set up. Skipping.
fi

# Set up tmwa and tmwa-server-data repositories and compile tmwa
if [ -d "/home/vagrant/tmwAthena/tmwa" ]; then
  echo "Checking for updates for the themanaworld/tmwa clone..."
  cd /home/vagrant/tmwAthena/tmwa
  TMWA_UPDT=$(git pull)
  if [ "$TMWA_UPDT" == "Already up-to-date." ]; then
    echo "themanaworld/tmwa clone is already up to date."
    # Make install just in case the clone is from a previous VM
    sudo make install &> /dev/null
  else
    echo "themanaworld/tmwa clone updated."
    echo "Rebuilding tmwa (please be patient, this can take some time)..."
    git submodule update --init &> /dev/null
    make clean &> /dev/null
    ./configure &> /dev/null
    make &> /dev/null
    sudo make install &> /dev/null
  fi
else
  echo "Cloning themanaworld/tmwa..."
  cd /home/vagrant/tmwAthena
  git clone --recursive git://github.com/themanaworld/tmwa.git &> /dev/null
  cd tmwa
  git submodule update --init &> /dev/null
  echo "Building tmwa (please be patient, this can take some time)..."
  ./configure &> /dev/null
  make &> /dev/null
  sudo make install &> /dev/null
  git config --global url.git@github.com:.pushInsteadOf git://github.com
fi
if [ -d "/home/vagrant/tmwAthena/tmwa-server-data" ]; then
  echo "Checking for updates for the themanaworld/tmwa-server-data clone..."
  cd /home/vagrant/tmwAthena/tmwa-server-data
  TMWASD_UPDT=$(git pull)
  if [ "$TMWASD_UPDT" == "Already up-to-date." ]; then
    echo "themanaworld/tmwa-server-data clone is already up to date."     
  else
    echo "themanaworld/tmwa-server-data clone updated."     
  fi 
else
  echo "Cloning themanaworld/tmwa-server-data..."
  cd /home/vagrant/tmwAthena
  git clone --recursive git://github.com/themanaworld/tmwa-server-data.git &> /dev/null
  cd tmwa-server-data
  echo "Setting up update hooks..."
  ln -s ../../git/hooks/post-merge .git/hooks/ &> /dev/null
  ln -s ../../../../git/hooks/post-merge .git/modules/client-data/hooks/ &> /dev/null
  echo Creating the configuration files...
  make conf &> /dev/null
  # Checkout master branches inside client-data
  cd client-data &> /dev/null
  git checkout master &> /dev/null
  cd music &> /dev/null
  git checkout master &> /dev/null
fi

# Run the tmwa server
cd /home/vagrant/tmwAthena/tmwa-server-data/
echo "Starting the server..."
./char-server& ./login-server& ./map-server& 
sleep 10

# Check for admin account and create it if it doesn't exist
cd /home/vagrant/tmwAthena/tmwa-server-data/login/save
CHK_ACC=$(cat account.txt | grep admin)
if [ "$CHK_ACC" == "" ]; then
  echo "GM account can't be found, creating..."
  cd /home/vagrant/tmwAthena/tmwa-server-data/login
  ladmin <<END
add admin M vagrant
gm admin 99
exit
exit
END
else
  echo "GM account is already set up."
fi

# Output info about the server
echo "######################################################################################"
echo "#                                                                                    #"
echo "#   Server is now running. You can reach it by adding a new server to your client:   #"
echo "#   Name: Local Server                                                               #"
echo "#   Address: localhost                                                               #"
echo "#   Port: 6901                                                                       #"
echo "#   Server type: TmwAthena                                                           #"
echo "#   A GM level 99 account has been created for you with the following credentials:   #"
echo "#   Username: admin                                                                  #"
echo "#   Password: vagrant                                                                #"
echo "#   Have fun!                                                                        #"
echo "#                                                                                    #"
echo "######################################################################################"