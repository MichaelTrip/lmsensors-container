FROM ubuntu:24.04

RUN apt update \
    && apt install -y lm-sensors fastfetch aha jq && apt clean

COPY sensors.sh /sensors.sh
RUN chmod +x /sensors.sh

CMD ["/bin/sh", "/sensors.sh"]
