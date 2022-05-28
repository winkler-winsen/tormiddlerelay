FROM alpine:latest
LABEL maintainer="lars@winkler-winsen.de"

ENV ORPORT=9001 \
    NICKNAME="test" \
    CONTACTINFO="email@here.pls" \
    RELAYBANDWIDTHRATE="2048 KB" \
    RELAYBANDWIDTHBURST="3072 KB"

RUN apk add --no-cache tor

RUN mkdir -p /etc/tor /var/lib/tor &&\
    addgroup alpine-tor &&\
    adduser --no-create-home --disabled-password -G alpine-tor alpine-tor &&\
    chown -R alpine-tor:alpine-tor /var/lib/tor/ &&\
    chmod 700 -R /var/lib/tor/ &&\
    echo ORPort $ORPORT > /etc/tor/torrc &&\
    echo RelayBandwidthRate $RELAYBANDWIDTHRATE >> /etc/tor/torrc &&\
    echo RelayBandwidthBurst $RELAYBANDWIDTHBURST >> /etc/tor/torrc &&\
    echo ContactInfo $CONTACTINFO >> /etc/tor/torrc &&\
    echo SocksPort 0 >> /etc/tor/torrc &&\
    echo ExitRelay 0 >> /etc/tor/torrc &&\
    echo DataDirectory /var/lib/tor >> /etc/tor/torrc

EXPOSE $ORPORT
VOLUME /var/lib/tor

USER alpine-tor

CMD ["/usr/bin/tor"]