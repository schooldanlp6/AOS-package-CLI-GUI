#!/bin/bash
if [ "$(whoami)" != "root" ]; then
    echo "Run as root."
    exit 1
fi
echo "Setting UP..."
sudo mkdir /etc/aospac
cd assets/scripts/binary
sudo cp wget /etc/aospac/wget
sudo cp gzip /etc/aospac/gzip
sudo cp gunzip /etc/aospac/gunzip
sudo cp gzexe /etc/aospac/gzexe
cd ..
cd main
sudo cp fetch /etc/aospac/fetch
sudo cp install /etc/aospac/install
sudo cp remove /etc/aospac/remove
sudo cp update /etc/aospac/update
sudo cp removeudata /etc/aospac/removeudata
sudo cp untar /etc/aospac/untar
cd /etc/aospac
#Please uncomment if back up files
#sudo cp repos repos.old
#sudo cp repos.d repos.d.old
sudo touch repos
sudo echo "#This is the repo list don't modify if you don't know what you do" > repos
sudo echo "#Here is what can be done to make a costum entry" >> repos
sudo echo "#You always need aos before the entry" >> repos
sudo echo "#It has to be Packages.gz" >> repos
sudo echo "#aos http://<filetransferprotocol.example.com>/<distname>/dists/<distversion>/main/binary-amd64/Packages.gz" >> repos
sudo echo "aos http://ftp.debian.org/debian/dists/bookworm/main/binary-amd64/Packages.gz" >> repos
sudo mkdir /etc/aospac/repos.d
sudo mkdir /etc/aospac/scripts
sudo touch pkgcache
echo "Using debian defaults"
#Dependencie check
echo "Checking for dependencies"
if command -v wget &> /dev/null; then
    echo "wget is installed."
else
    echo "wget is not installed."
fi
if command -v gzip &> /dev/null; then
    echo "gzip is installed."
else
    echo "gzip is not installed."
fi
read -p "Do you want to install? (y/n): " choice
if [ "$choice" != "y" ]; then
    echo "Choose an option:"
    echo "1. Install wget"
    echo "2. Install gzip"
    echo "3. Install both"
    echo "4. Continue"
    read -p "Enter your choice (1/2/3/4): " choice2
    case $choice2 in
    1)
        if [ "$wget_installed" = false ]; then
            # Install wget if not installed
            echo "Installing wget..."
	    chmod +x ./wget
	    mv wget /usr/bin/wget
            # Add the installation command here (e.g., sudo apt-get install wget)
        else
            echo "wget is already installed."
        fi
        ;;
    2)
        if [ "$gzip_installed" = false ]; then
            # Install gzip if not installed
            echo "Installing gzip..."
	    chmod +x gzip
	    chmod +x gunzip
	    chmod +x gzexe
	    mv gzip /usr/bin/gzip
	    mv gunzip /usr/bin/gunzip
	    mv gzexe /usr/bin/gzexe
            # Add the installation command here (e.g., sudo apt-get install gzip)
        else
            echo "gzip is already installed."
	    rm -fr ./gzip
	    rm -fr ./gunzip
	    rm -fr ./gzexe
        fi
        ;;
    3)
        # Install both wget and gzip
        echo "Installing wget and gzip..."
        chmod +x *
	mv wget /usr/bin/wget
	mv gzip /usr/bin/gzip
	mv gunzip /usr/bin/gunzip
	mv gzexe /usr/bin/gzexe
        ;;
    4)
        echo "starting unsafe install"
	rm -fr ./gzip
	rm -fr ./gunzip
	rm -fr ./wget
	rm -fr ./gzexe
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
    esac
else
    echo "Continuing..."
fi
#Continue Installing
echo "----------------"
echo "Adding Scripts..."
echo "----------------"
sudo mv fetch scripts/fetch
cd scripts
sudo sh ./fetch
cd ..
