#!/usr/bin/env bash

# Based on original script from https://github.com/Bugswriter/myyt

if [[ -z "$1" ]]; then
  read -rp "Search query: " query
else
	query="$1"
fi

query="${query// /+}"
echo "$query"

# YT_API_KEY location
YT_API_KEY="$( cat "${HOME}"/.api_keys/YT_API_KEY )"
urlstring="https://www.googleapis.com/youtube/v3/search?part=snippet&q=${query}&type=video&maxResults=20&key=${YT_API_KEY}"
echo $urlstring

mpv "https://$( curl -s "${urlstring}" \
	| jq -r '.items[] | "\(.snippet.channelTitle) => \(.snippet.title) youtu.be/\(.id.videoId)"' \
	| fzf --with-nth='1..-2' +m \
	| awk '{print $NF}' \
)"
