#!/bin/sh
cd ../
git clone https://github.com/DSM-PICK/PiCK_iOS_V2_XCConfig.git
mv PiCK_iOS_V2_XCConfig/XCConfig/.

git clone https://github.com/DSM-PICK/PiCK-iOS-GoogleInfo.git
mv PiCK-iOS-GoogleInfo/FireBase/Projects/App/Resources/

brew install make

curl https://mise.jdx.dev/install.sh | sh
export PATH="$HOME/.local/bin:$PATH"
eval "$(mise activate bash --shims)"

mise install tuist@3.40.0

tuist version

make clean
make cache_clean

tuist fetch
TUIST_CI=1 tuist generate
