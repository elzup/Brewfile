# 定期ジョブメモ (launchd / crontab)

このマシンの定期ジョブの一覧と復元手順。
スクリプト本体は各 repo にあり、詳細はそれぞれの README を参照する。
(private repo の内容はここには書かない)

## launchd — この repo が管理 (install.sh が plist を配置)

| plist                | schedule    | 概要                       |
| -------------------- | ----------- | -------------------------- |
| dump.brewfile.plist  | 毎日 06:00  | Brewfile 自動バックアップ  |
| setenv.plist         | 起動時      | launchd 環境変数設定       |
| minutely.plist       | 60 秒ごと   | elzup/minutely の run.sh   |

復元: `./install.sh` (plist を `~/Library/LaunchAgents` へ copy + load)

## launchd — 各 repo が plist を持つ (symlink 運用)

| label                       | schedule   | repo                  |
| --------------------------- | ---------- | --------------------- |
| com.elzup.daily-report-ai   | 毎日 00:00 | elzup/daily-report-ai |
| com.elzup.daily-report-viewer | -        | elzup/daily-report-ai |
| com.elzup.daily-check       | 毎日 10:00 | elzup/daily-check (private、詳細は repo へ) |

復元手順:

```sh
ghq get <repo>
ln -sf ~/.ghq/github.com/elzup/<repo>/<label>.plist ~/Library/LaunchAgents/
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/<label>.plist
```

## crontab

| schedule   | repo         | 概要                  |
| ---------- | ------------ | --------------------- |
| 毎日 00:00 | elzup/kit-sh | vscode theme 切り替え |

復元: repo README の cron 例を `crontab -e` で登録。確認は `crontab -l`。
