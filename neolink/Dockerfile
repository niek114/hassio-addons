FROM quantumentangledandy/neolink:v0.6.2

RUN apt-get update && \
    apt-get install -y \
        jq && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Copy rootfs for add-on
COPY rootfs/ /
RUN chmod a+x /run.sh

WORKDIR /config

CMD [ "/run.sh" ]
