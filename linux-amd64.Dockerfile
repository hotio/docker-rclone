FROM ubuntu:18.04 as builder

ARG DEBIAN_FRONTEND="noninteractive"

# install
RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        ca-certificates curl unzip

# install rclone
ARG RCLONE_VERSION
RUN zipfile="/tmp/rclone.zip" && curl -fsSL -o "${zipfile}" "https://github.com/ncw/rclone/releases/download/v${RCLONE_VERSION}/rclone-v${RCLONE_VERSION}-linux-amd64.zip" && unzip -q "${zipfile}" -d "/tmp" && cp /tmp/rclone-*-linux-amd64/rclone /usr/local/bin/rclone && chmod 755 /usr/local/bin/rclone


FROM ubuntu@sha256:b58746c8a89938b8c9f5b77de3b8cf1fe78210c696ab03a1442e235eea65d84f
LABEL maintainer="hotio"

ARG DEBIAN_FRONTEND="noninteractive"

ENTRYPOINT ["rclone"]

# install packages
RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        fuse && \
# clean up
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

COPY --from=builder /usr/local/bin/rclone /usr/local/bin/rclone
