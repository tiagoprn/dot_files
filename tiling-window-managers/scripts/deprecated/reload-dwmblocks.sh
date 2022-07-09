#!/bin/bash
pkill dwmblocks || true && xsetroot -name "Restarting dwmblocks...[WAIT A MOMENT]" && nohup xsetroot -name "$(dwmblocks)" &
