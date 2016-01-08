#!/bin/bash
THIS_DIR=$(cd $(dirname $0); pwd)

export TELEGRAM_HOME=$THIS_DIR

./tg/bin/telegram-cli -k ./tg/tg-server.pub -s ./main.lua -l 1 -E $@
