#!/bin/sh

set -e
set -u

repository=$HOME/Brewfile

cd "$repository"
rm Brewfile
/usr/local/bin/brew bundle dump -f
/usr/local/bin/npm list --global --parseable --depth=0 | sed '1d' | awk '{gsub(/\/.*\//,"",$1); print}' > npm-global-list
/usr/bin/git add .
/usr/bin/git commit -m "Backup Brewfile `date "+%Y-%m-%d %H:%M:%S"`"
/usr/bin/git push origin master
osascript -e 'display notification "Finish backing up  Brewfile" with title "Brewfile"'
