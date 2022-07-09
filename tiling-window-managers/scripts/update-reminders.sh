#!/bin/bash

cd /storage/docs/reminders && \
echo -e "\n\n\n"
echo -e "********************************************************************************************" && \
echo -e "$(date +%Y%m%d-%H%M%S): Commiting and pushing to reminders repo..." && \
git add . && \
git commit -m "automated commit on $(hostname) at $(date '+%A %d, %B %Y %H:%M:%S')" > /dev/null && \
git push origin master > /dev/null 2>&1 && \
echo -e "----------" && \
git glog -n 3 && \
echo -e "----------" && \
git files-changed -n 1 && \
echo -e "----------" && \
echo -e "SUCCESSFULLY FINISHED! o/" && \
echo -e "----------" && \
lock-terminal-for-input.sh
