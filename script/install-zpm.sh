#!/bin/bash
install_dir=~/.zpm_install/

root=$(pwd)
OS=$(uname)

if [ "$OS" == "Darin"]; then
    premakeURL="https://github.com/premake/premake-core/releases/download/v5.0.0-alpha11/premake-5.0.0-alpha11-macosx.tar.gz"
else
    premakeURL="https://github.com/premake/premake-core/releases/download/v5.0.0-alpha11/premake-5.0.0-alpha11-linux.tar.gz"
fi

rm -rf $install_dir || true

mkdir -p $install_dir
cd $install_dir

rm -f premake5.tar.gz || true

echo $premakeURL
curl -L -o premake5.tar.gz $premakeURL
tar xzf premake5.tar.gz
chmod a+x premake5

git clone https://github.com/Zefiros-Software/ZPM.git ./zpm --depth 1 -b features/refactor

if [ -z "$GH_TOKEN" ]; then
    ./premake5 --file=zpm/zpm.lua install zpm
else
    ./premake5 --github-token=$GH_TOKEN --file=zpm/zpm.lua install zpm
fi

cd $root

rm -rf $install_dir



if [ "$OS" == "Darin"]; then
    source ~/.bash_profile
else
    source ~/.bashrc
fi