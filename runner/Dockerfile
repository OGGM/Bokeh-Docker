FROM alpine:3

RUN apk add --update --no-cache docker-cli docker-compose git bash

ENV \
	WS_ORIGIN=bokeh.oggm.org \
	LE_DOMAIN=bokeh.oggm.org \
	ACME_EMAIL=timo.rothenpieler@uni-bremen.de \
	ACME_DIR=/home/timo/acme

COPY run.sh /root/run.sh
WORKDIR /root
ENTRYPOINT ["/root/run.sh"]
