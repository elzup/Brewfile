#!/bin/sh

set -e
set -u

setup(){
  Brewfile=$HOME/Brewfile
  launchd=$HOME/Library/LaunchAgents

  if [ ! -d "$Brewfile" ]; then
      git clone https://github.com/elzup/Brewfile "$Brewfile"
  fi

  if [ ! -d "$launchd" ]; then
    mkdir "$launchd"
  fi

  cp -f "$Brewfile/dump.brewfile.plist" "$launchd/dump.brewfile.plist"
  reload "dump.brewfile.plist"
  cp -f "$Brewfile/setenv.plist" "$launchd/setenv.plist"
  reload "setenv.plist"
  cp -f "$Brewfile/minutely.plist" "$launchd/minutely.plist"
  reload "minutely.plist"
}

# MEMO:
# すでにloadされている場合に再度同じラベルをloadするとerrorが発生する...
# が exit code 0 を返されるため、エラーハンドリングができない
load(){
  launchctl load ~/Library/LaunchAgents/$1
}

reload(){
  echo "Unload $1"
  launchctl unload ~/Library/LaunchAgents/$1
  echo "Load $1"
  load "$1"
}

setup
