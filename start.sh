#!/bin/bash

export PORT=5103

cd ~/www/rowgame
./bin/rowgame stop || true
./bin/rowgame start

