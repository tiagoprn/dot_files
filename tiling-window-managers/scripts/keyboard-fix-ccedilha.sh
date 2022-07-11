#!/bin/bash

set -eou pipefail

sudo -- bash -c "cp -farv /etc/environment /etc/environment.snapshot.$(date +%Y%m%d-%H%M%S-%N) && echo 'GTK_IM_MODULE=cedilla' >> /etc/environment"
