#!/bin/bash
ps axc -o pid,cmd:15,%cpu --sort=-%cpu | head
