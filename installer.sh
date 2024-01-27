if [$(whoami) != root];
then echo "Run as Root" && exit
fi
echo "Setting UP..."
mkdir /etc/aospac
cd /etc/aospac
touch repos
mkdir /etc/aospac/repos.d
touch pkgcache
echo "Using debian defaults"

