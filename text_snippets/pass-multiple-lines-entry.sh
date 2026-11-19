#!/usr/bin/env bash

cat <<EOF
password: ""
username: ""
name: ""
uri: ""
notes: |-
  line 1
  ...
  line 3
creation-date: "$(date "+%Y-%-m-%d %H:%M:%S")"
revision-date: "$(date "+%Y-%-m-%d %H:%M:%S")"
EOF
