FROM ubuntu:24.04

RUN apt update \
    && apt install -y lm-sensors aha jq curl wget && apt clean

# Install fastfetch using the latest version
RUN /bin/sh -c "FASTFETCH_VERSION=$(curl -s https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest | jq -r .tag_name); \
                wget https://github.com/fastfetch-cli/fastfetch/releases/download/${FASTFETCH_VERSION}/fastfetch-linux-amd64.deb -O /tmp/fastfetch.deb; \
                dpkg -i /tmp/fastfetch.deb; \
                rm /tmp/fastfetch.deb"

COPY sensors.sh /sensors.sh
RUN chmod +x /sensors.sh

CMD ["/bin/sh", "/sensors.sh"]
