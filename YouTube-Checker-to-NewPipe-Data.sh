#!/usr/bin/env bash
help() {
    echo 'Usage: YouTube-Checker-to-NewPipe-Data.sh YouTube-Checker.json NewPipeData.zip'
    echo 'Needs `jq`, `unzip`, and `sqlite3` installed.'
    exit 0
}
[[ ! -f $1 || ! -f $2 ]] && help
echo 'Warning: Avatars, subscriber count, and description will be missing in NewPipe.'
youtube_checker=$(jq -r '.[][] | "\(.id) \(.title)"' "$1" 2>/dev/null || help)
newpipe_dir=$(mktemp -d)
unzip "$2" -d "$newpipe_dir" || help
sqlite3 "$newpipe_dir/newpipe.db" 'delete from subscriptions;' || help
while read -r line; do
    channel_id=$(cut -d ' ' -f 1 <<< "$line")
    channel_name=$(cut -d ' ' -f 2- <<< "$line")
    sqlite3 "$newpipe_dir/newpipe.db" "insert into subscriptions (service_id, url, name, avatar_url, subscriber_count, description) values (0, \"https://www.youtube.com/channel/$channel_id\", \"$channel_name\", \"\", 0, \"\");"
done <<< "$youtube_checker"
rm NewPipeData-YouTube-Checker.zip 2>/dev/null
zip -j NewPipeData-YouTube-Checker.zip "$newpipe_dir/newpipe.db" "$newpipe_dir/newpipe.settings"
echo 'Created ZIP archive NewPipeData-YouTube-Checker.zip.  Don’t forget that you should *not* import the settings!'
