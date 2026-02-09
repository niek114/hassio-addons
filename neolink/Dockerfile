FROM quantumentangledandy/neolink:v0.6.2

RUN apt-get update && \
    apt-get install -y \
        jq && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Copy data for App
COPY rootfs/run.sh /run.sh
RUN chmod a+x /run.sh

WORKDIR /config

CMD [ "/run.sh" ]
