#!/usr/bin/env bash

# Update all packages
su vagrant
echo "Updating the Virtual Machine (if this is the first time you're running this"
echo "machine, it can take some time)..."
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
  echo "Switching to branch master to preserve local changes..."
  git checkout master &> /dev/null || echo "[Error] Failed to switch branches."
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
  git clone --recursive git://github.com/themanaworld/tmwa.git &> /dev/null || echo "[Error] Cloning tmwa failed."
  cd /home/vagrant/tmwAthena/tmwa/deps/attoconf
  sudo ./setup.py install &> /dev/null
  cd /home/vagrant/tmwAthena/tmwa
  echo "Building tmwa (please be patient, this can take some time)..."
  ./configure &> /dev/null || echo "[Error] Configure failed for tmwa."
  make &> /dev/null || echo "[Error] Building tmwa failed."
  sudo make install &> /dev/null || echo "[Error] Make install for tmwa failed."
  git config --global url.git@github.com:.pushInsteadOf git://github.com
fi
if [ -d "/home/vagrant/tmwAthena/tmwa-server-data" ]; then
  echo "Checking for updates for the themanaworld/tmwa-server-data clone..."
  cd /home/vagrant/tmwAthena/tmwa-server-data
  echo "Switching to branch master to preserve local changes..."
  git checkout master &> /dev/null || echo "[Error] Failed to switch branches."
  TMWASD_UPDT=$(git pull)
  if [ "$TMWASD_UPDT" == "Already up-to-date." ]; then
    echo "themanaworld/tmwa-server-data clone is already up to date."
  else
    echo "Updating magic..."
    cd /home/vagrant/tmwAthena/tmwa-server-data/world/map/conf
    wget -N -O spells-build https://gist.github.com/DinoPaskvan/6283572/raw/56b607a04990f396ad9a1c9af5a72663bc62cedf/spells-build &> /dev/null
    chmod 777 spells-build
    cp magic.conf.template magic.conf
    ./build-magic.sh
    echo "themanaworld/tmwa-server-data clone updated."
  fi
else
  echo "Cloning themanaworld/tmwa-server-data..."
  cd /home/vagrant/tmwAthena
  git clone --recursive git://github.com/themanaworld/tmwa-server-data.git &> /dev/null || echo "[Error] Cloning tmwa-server-data failed."
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
  # Set up magic
  echo "Setting up magic..."
  cd /home/vagrant/tmwAthena/tmwa-server-data/world/map/conf
  wget -O spells-build https://gist.github.com/DinoPaskvan/6283572/raw/ae439049895f89925550127e9d22b80761cd2d6b/spells-build &> /dev/null
  chmod 777 spells-build
  cp magic.conf.template magic.conf
  ./build-magic.sh
fi

# Run the tmwa server
cd /home/vagrant/tmwAthena/tmwa-server-data/
echo "Starting the server..."
./char-server& ./login-server& ./map-server&
sleep 15

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
echo "##############################################################################"
echo "#                                                                            #"
echo "#   Server is now running. You can reach it by adding a new server to your   #"
echo "#   client:                                                                  #"
echo "#   Name: Local Server                                                       #"
echo "#   Address: localhost                                                       #"
echo "#   Port: 6901                                                               #"
echo "#   Server type: TmwAthena                                                   #"
echo "#   A GM level 99 account has been created for you with the following        #"
echo "#   credentials:                                                             #"
echo "#   Username: admin                                                          #"
echo "#   Password: vagrant                                                        #"
echo "#   Have fun!                                                                #"
echo "#                                                                            #"
echo "##############################################################################"
