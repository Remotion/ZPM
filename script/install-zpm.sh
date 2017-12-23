#!/bin/bash
install_dir=~/.zpm_install/

root=$(pwd)
OS=$(uname)

rm -rf $install_dir || true

mkdir -p $install_dir
cd $install_dir

rm -f premake5.tar.gz || true
if [[ "$OS" == "Darwin" ]]; then

    premakeURL="https://github.com/Zefiros-Software/premake-core/releases/download/v5.0.0-zpm-alpha12.2-dev/premake-macosx.tar.gz"
else
    premakeURL="https://github.com/Zefiros-Software/premake-core/releases/download/v5.0.0-zpm-alpha12.2-dev/premake-linux.tar.gz"
fi

curl -L -s -o premake5.tar.gz $premakeURL
tar -xzf premake5.tar.gz
chmod a+x premake5

./premake5 --version

if [ $? -eq 0 ]; then
    # compile premake5
    cd premake-core
    git clone https://github.com/Zefiros-Software/premake-core.git

    if [[ "$OS" == "Darwin" ]]; then
        make -f Bootstrap.mak osx
    else    
        make -f Bootstrap.mak linux
    fi

    make -C build/bootstrap -j config=debug
    cd ../
    mv premake-core/bin/release/premake5 premake5

    # continue installation
    chmod a+x premake5
fi


git clone https://github.com/Zefiros-Software/ZPM.git ./zpm --depth 1 --quiet -b features/refactor

ZPM_DIR=$(./premake5 show install --file=zpm/zpm.lua | xargs) 

if [ -z "$GH_TOKEN" ]; then
    ./premake5 --file=zpm/zpm.lua install zpm --verbose
else
    ./premake5 --github-token=$GH_TOKEN --file=zpm/zpm.lua install zpm --verbose
fi

cd $root

rm -rf $install_dir

source ~/.profile
