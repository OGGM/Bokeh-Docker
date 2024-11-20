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
	rm -rf "${APPDIR}"
	if [[ "$GITSTR" == *@* ]]; then
		GITCOMMIT="${GITSTR##*@}"
		git init "${APPDIR}"
		git -C "${APPDIR}" remote add origin "${GITURL}"

		RES=0
		git -C "${APPDIR}" fetch origin "$GITCOMMIT" || RES=$?
		git -C "${APPDIR}" reset --hard "$GITCOMMIT" || RES=$?

		if [[ $RES != 0 ]]; then
			echo "Falling back to full fetch..."
			git -C "${APPDIR}" fetch origin
			git -C "${APPDIR}" checkout "$GITCOMMIT"
		fi
	else
		git clone --depth=1 "${GITURL}" "${APPDIR}"
	fi
	rm -rf "${APPDIR}/.git"
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

exec panel serve "$APP" \
	--address 0.0.0.0 \
	--port 8080 \
	--allow-websocket-origin "$BOKEH_ALLOW_WS_ORIGIN" \
	--use-xheaders \
	--num-procs "$BOKEH_NUM_PROCS" \
	--prefix "$BOKEH_PREFIX"
