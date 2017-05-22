#!/bin/sh

set -e
set -u

repository=$HOME/Brewfile

cd "$repository"
/usr/local/bin/brew bundle dump -f
/usr/bin/git add .
/usr/bin/git commit -m "Backup Brewfile `date "+%Y-%m-%d %H:%M:%S"`"
/usr/bin/git push origin master
osascript -e 'display notification "Finish backing up  Brewfile" with title "Brewfile"'
