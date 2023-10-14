#!/usr/bin/env bash
rm -r ~/bin/platform-tools
rm platform-tools-latest-linux.zip
wget https://dl.google.com/android/repository/platform-tools-latest-linux.zip
sleep 5
unzip platform-tools-latest-linux.zip -d ~/bin/platform-tools
# add Android SDK platform tools to path
echo "if [ -d "\$HOME/bin/platform-tools" ] ; then" >> ~/.bashrc
echo "    PATH="\$HOME/bin/platform-tools:\$PATH"" >> ~/.bashrc
echo "fi" >> ~/.bashrc