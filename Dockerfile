FROM alpine:3.20

WORKDIR /tmp/overlay-demo

COPY ./docker-overlayFS.sh ./

RUN chmod +x ./docker-overlayFS.sh

ENTRYPOINT ["./docker-overlayFS.sh"]