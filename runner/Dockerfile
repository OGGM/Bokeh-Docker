FROM alpine:3

RUN apk add --update --no-cache docker-cli docker-compose git bash

ENV \
	WS_ORIGIN=bokeh.oggm.org

COPY run.sh /root/run.sh
WORKDIR /root
ENTRYPOINT ["/root/run.sh"]
