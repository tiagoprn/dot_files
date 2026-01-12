#!/usr/bin/env bash

cd /storage/src/mindshards \
    && clear \
    && echo -e "Will open nvim to create the shard file.\nRun - zk w - to push to the repo;\nRun - zk f - to pull from the repo." \
    && read -n1 -s -r -p "Press any key to continue..." \
    && zk shard
