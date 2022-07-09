#!/bin/bash
ps axc -o pid,cmd:15,%mem --sort=-%mem | head
