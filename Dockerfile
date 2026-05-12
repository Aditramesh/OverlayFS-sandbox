FROM alpine:3.20

COPY ./overlayFS.sh ./

RUN chmod +x ./overlayFS.sh

ENTRYPOINT ["./overlayFS.sh"]