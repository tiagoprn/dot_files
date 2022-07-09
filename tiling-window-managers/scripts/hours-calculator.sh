#!/bin/bash

PY_BIN=$HOME/.pyenv/versions/chronator/bin/python
TIME_RECORDS_FILE=/storage/docs/vim_notes/work/dafiti/TIMESHEET.md
ROOT_MODULE_FOLDER=/storage/src/chronator

cd $ROOT_MODULE_FOLDER && \
	make clean && \
	cat $TIME_RECORDS_FILE | \
	grep -E -o '^# [0-9]{2}\/[0-9]{2} \([0-9]{2}.+\)' | \
	$PY_BIN chronator/calculator.py --mode elapsed_hours | \
	$PY_BIN chronator/calculator.py --mode hours_balance | \
	$PY_BIN chronator/calculator.py --mode total_hours;
