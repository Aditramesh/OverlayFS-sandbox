FROM alpine:3.20

COPY ./docker-overlayFS.sh ./

RUN chmod +x ./docker-overlayFS.sh

ENTRYPOINT ["./docker-overlayFS.sh"]