#!/bin/bash 
#Thanx to https://howchoo.com/g/ztbhyzfknze/how-to-install-pocketsphinx-on-a-raspberry-pi by Tyler 

#Utility per verificare se un programma e' presente o meno
installato () {
    type "$1" &> /dev/null ;
}


#Verifico se già installato
if installato pocketsphinx_continuous ; then    
	echo -e '\e[38;5;196m Pocketsphinx già installato!\n'
else

#Pocketphinx richiede pulseaudio
if installato pulseaudio ; then
    echo -e "\e[38;5;192m Pulseaudio già installato."  		
else
    echo -e "\e[38;7;255m Installo Pulseaudio..."  	
	sudo apt-get update
    sudo apt-get install pulseaudio
	pulseaudio --start
fi


echo -e "\e[38;7;255m downloads from GitHub"
wget https://sourceforge.net/projects/cmusphinx/files/sphinxbase/5prealpha/sphinxbase-5prealpha.tar.gz/download -O sphinxbase.tar.gz
wget https://sourceforge.net/projects/cmusphinx/files/pocketsphinx/5prealpha/pocketsphinx-5prealpha.tar.gz/download -O pocketsphinx.tar.gz

echo -e "\e[38;7;255m Extract the files into separate directories"
tar -xzvf sphinxbase.tar.gz
tar -xzvf pocketsphinx.tar.gz

echo -e "\e[38;7;255m Install bison, ALSA, and swig"
sudo apt-get install bison libasound2-dev swig

echo -e "\e[38;7;255m Compile sphinxbase"
cd sphinxbase-5prealpha
./configure --enable-fixed
make
sudo make install

echo -e "\e[38;7;255m Compile pocketsphinx"
cd ../pocketsphinx-5prealpha
./configure
make
sudo make install

echo -e "\e[38;7;255m Test out the installation"
src/programs/pocketsphinx_continuous -inmic yes 
fi
