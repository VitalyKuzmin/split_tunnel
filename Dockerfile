FROM ubuntu:22.04

RUN apt update && apt install -y iproute2 jq

COPY toggle_split_tunneling.sh /usr/local/bin/toggle_split_tunneling.sh
COPY ip-list.json /root/ip-list.json

RUN chmod +x /usr/local/bin/toggle_split_tunneling.sh

ENTRYPOINT ["/usr/local/bin/toggle_split_tunneling.sh"]