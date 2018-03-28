#!/bin/bash

export PORT=5103
export MIX_ENV=prod
export GIT_PATH=/home/rowgame/src/rowgame

PWD=`pwd`
if [ $PWD != $GIT_PATH ]; then
	echo "Error: Must check out git repo to $GIT_PATH"
	echo "  Current directory is $PWD"
	exit 1
fi

if [ $USER != "rowgame" ]; then
	echo "Error: must run as user 'rowgame'"
	echo "  Current user is $USER"
	exit 2
fi

mix deps.get
(cd assets && npm install)
(cd assets && ./node_modules/brunch/bin/brunch b -p)
mix phx.digest

mix release --env=prod

mkdir -p ~/www
mkdir -p ~/old

NOW=`date +%s`
if [ -d ~/www/rowgame ]; then
	echo mv ~/www/rowgame ~/old/$NOW
	mv ~/www/rowgame ~/old/$NOW
fi

mkdir -p ~/www/rowgame
REL_TAR=~/src/rowgame/_build/prod/rel/rowgame/releases/0.0.1/rowgame.tar.gz
(cd ~/www/rowgame && tar xzvf $REL_TAR)

MIX_ENV=prod mix ecto.create
MIX_ENV=prod mix ecto.migrate


crontab - <<CRONTAB
@reboot bash /home/rowgame/src/rowgame/start.sh
CRONTAB

#. start.sh
