#!/usr/bin/env bash

# Original script name: dmsearch
# Description: Search various search engines (inspired by surfraw).
# Dependencies: dmenu and a web browser
# GitLab: https://www.gitlab.com/dwt1/dmscripts
# License: https://www.gitlab.com/dwt1/dmscripts/LICENSE
# Contributors: Derek Taylor
#               Ali Furkan Yıldız

# Defining our web browser.
DMBROWSER="firefox"

# An array of search engines.  You can edit this list to add/remove
# search engines. The format must be: "engine_name]="url".
# The url format must allow for the search keywords at the end of the url.
# For example: https://www.amazon.com/s?k=XXXX searches Amazon for 'XXXX'.
declare -A options
options[amazon]="https://www.amazon.com/s?k="
options[archaur]="https://aur.archlinux.org/packages/?O=0&K="
options[archpkg]="https://archlinux.org/packages/?sort=&q="
options[archwiki]="https://wiki.archlinux.org/index.php?search="
options[arxiv]="https://arxiv.org/search/?searchtype=all&source=header&query="
options[bing]="https://www.bing.com/search?q="
options[debianpkg]="https://packages.debian.org/search?suite=default&section=all&arch=any&searchon=names&keywords="
options[duckduckgo]="https://duckduckgo.com/?q="
options[github]="https://github.com/search?q="
options[gitlab]="https://gitlab.com/search?search="
options[imdb]="https://www.imdb.com/find?q="
options[lbry]="https://lbry.tv/$/search?q="
options[odysee]="https://odysee.com/$/search?q="
options[reddit]="https://www.reddit.com/search/?q="
options[startpage]="https://www.startpage.com/do/dsearch?query="
options[thesaurus]="https://www.thesaurus.com/misspelling?term="
options[translate]="https://translate.google.com/?sl=auto&tl=en&text="
options[urban]="https://www.urbandictionary.com/define.php?term="
options[wayback]="https://web.archive.org/web/*/"
options[webster]="https://www.merriam-webster.com/dictionary/"
options[wikipedia]="https://en.wikipedia.org/wiki/"
options[wiktionary]="https://en.wiktionary.org/wiki/"
options[wolfram]="https://www.wolframalpha.com/input/?i="
options[youtube]="https://www.youtube.com/results?search_query="
options[google]="https://www.google.com/search?q="
options[googleimages]="https://www.google.com/search?hl=en&tbm=isch&q="
options[googlenews]="https://news.google.com/search?q="
options[googleStructuredData]="https://search.google.com/structured-data/testing-tool#url="
options[googleDevelopers]="https://developers.google.com/s/results?q="
options[googleOpenSource]="https://opensource.google/projects/search?q="
options[googleDataset]="https://datasetsearch.research.google.com/search?query="
options[pypi]="https://pypi.org/search/?q="
options[dockerhub]="https://hub.docker.com/search?q="
options[quay]="https://quay.io/search?q="

# Picking a search engine.
# shellcheck disable=SC2154
while [ -z "$engine" ]; do
    engine=$(printf '%s\n' "${!options[@]}" | sort | dmenu -i -l 20 -p 'Choose search engine:') "$@" || exit
    url="${options["${engine}"]}" || exit
done

# Searching the chosen engine.
# shellcheck disable=SC2154
while [ -z "$query" ]; do
    query=$(echo "$engine" | dmenu -p 'Enter search query:') "$@" || exit
done

# Display search results in web browser
$DMBROWSER "$url""$query"
