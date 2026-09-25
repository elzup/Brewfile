#!/bin/sh

set -e
set -u

repository=$HOME/Brewfile

cd "$repository"
rm Brewfile

/opt/homebrew/bin/brew bundle dump -f
/usr/local/bin/npm list --global --parseable --depth=0 | sed '1d' | awk '{gsub(/\/.*\//,"",$1); print}' > npm-global-list
/usr/bin/git add .
# 変更の無い日に commit が exit 1 になり、set -e でジョブ全体が失敗扱いになるのを避ける。
# push は毎回行い、過去に失敗して溜まった未 push 分も送る
/usr/bin/git diff --cached --quiet || /usr/bin/git commit -m "Backup Brewfile `date "+%Y-%m-%d %H:%M:%S"`"
# refspec を明示する。ブランチ名を master から main に変えた後も master へ push していて毎日失敗していた
/usr/bin/git push origin HEAD:refs/heads/main
osascript -e 'display notification "Finish backing up  Brewfile" with title "Brewfile"'
