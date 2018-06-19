FROM linkyard/docker-helm:2.9.1

RUN apk add --update --upgrade --no-cache jq bash

ADD assets /opt/resource
RUN chmod +x /opt/resource/*

ENTRYPOINT [ "/bin/bash" ]
