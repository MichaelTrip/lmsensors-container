FROM ubuntu:24.04

RUN apt update \
    && apt install -y lm-sensors aha jq wget && apt clean

RUN /bin/sh -c "export FASTFETCH_VERSION=$(curl https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest | jq .name); \
                wget https://github.com/fastfetch-cli/fastfetch/releases/download/2.21.3/fastfetch-linux-amd64.deb -O /tmp/fastfetch.deb; \
                dpkg -i /tmp/fastfetch.deb"

COPY sensors.sh /sensors.sh

CMD ["/bin/sh", "/sensors.sh"]