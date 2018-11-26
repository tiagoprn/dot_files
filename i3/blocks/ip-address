#!/bin/bash

echo "$(ip addr | grep 'inet ' | grep -v 127 | grep -v 172 | awk '{gsub("/"," ",$2); print $2}' | awk '{print $1}')"
