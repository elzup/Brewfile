#!/bin/sh

set -e
set -u

repository=$HOME/Brewfile

# launchd は最小限の PATH しか渡さない。brew bundle dump は npm のグローバルパッケージと
# VS Code 拡張も Brewfile に含めるので、mise 管理の node / npm (shims) と code (/usr/local/bin) を通す。
# /usr/local/bin にも node 無しの npm があるため、shims を必ずその前に置く
export PATH="$HOME/.local/share/mise/shims:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

cd "$repository"

# dump が失敗しても既存の Brewfile を消さないよう、一時ファイルに書いてから置き換える
# (先に rm していたため、2026-11-04 に dump が失敗した後 Brewfile が消えたまま毎日落ちていた)
tmp_brewfile=$(mktemp "$repository/.Brewfile.XXXXXX")
trap 'rm -f "$tmp_brewfile"' EXIT
/opt/homebrew/bin/brew bundle dump --force --file="$tmp_brewfile"
mv "$tmp_brewfile" Brewfile

# PUBLIC リポへ自動 push するので、新規ファイルは拾わず追跡済みファイルの変更だけを載せる
/usr/bin/git add -u
# 変更の無い日に commit が exit 1 になり、set -e でジョブ全体が失敗扱いになるのを避ける。
# push は毎回行い、過去に失敗して溜まった未 push 分も送る
/usr/bin/git diff --cached --quiet || /usr/bin/git commit -m "Backup Brewfile `date "+%Y-%m-%d %H:%M:%S"`"
# refspec を明示する。ブランチ名を master から main に変えた後も master へ push していて毎日失敗していた
/usr/bin/git push origin HEAD:refs/heads/main
osascript -e 'display notification "Finish backing up  Brewfile" with title "Brewfile"'
