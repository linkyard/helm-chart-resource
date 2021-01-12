FROM linkyard/alpine-helm:2.17.0

RUN apk add --update --upgrade --no-cache jq bash

ADD assets /opt/resource
RUN chmod +x /opt/resource/*

ENTRYPOINT [ "/bin/bash" ]
