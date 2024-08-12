FROM ubuntu:24.04

RUN apt-get update \
    && apt-get install -y lm-sensors

COPY sensors.sh /sensors.sh

CMD ["/bin/sh", "/sensors.sh"]