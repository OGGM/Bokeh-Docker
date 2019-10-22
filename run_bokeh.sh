#!/bin/bash
set -e

if [[ -z "$BOKEH_ALLOW_WS_ORIGIN" || "$BOKEH_ALLOW_WS_ORIGIN" == "auto" ]]; then
	export BOKEH_ALLOW_WS_ORIGIN="$(hostname),$(getent hosts $(hostname) | cut -d" " -f1)"
fi

if [[ "$#" != 2 ]]; then
	echo "usage: $0 path/to/app app.py"
	exit -1
fi

APPDIR="$1"
APP="$2"

if [[ "$APPDIR" == git+* ]]; then
	GITSTR="${APPDIR:4}"
	APPDIR="app"
	GITURL="${GITSTR%@*}"
	git clone "${GITURL}" app
	if [[ "$GITSTR" == *@* ]]; then
		GITCOMMIT="${GITSTR##*@}"
		git -C app checkout "$GITCOMMIT"
	fi
fi

if ! [[ -d "$APPDIR" ]]; then
	echo "Appdir $APPDIR not found."
	exit -1
fi

cd "$APPDIR"

if [[ -f requirements.txt ]]; then
	$PIP install --no-cache-dir -r requirements.txt
fi

if ! [[ -f "$APP" ]]; then
	echo "App $APP not found."
	exit -1
fi

exec bokeh serve "$APP" \
	--address 0.0.0.0 \
	--port 8080 \
	--use-xheaders \
	--num-procs "$BOKEH_NUM_PROCS" \
	--prefix "$BOKEH_PREFIX"

