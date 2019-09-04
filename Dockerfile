# Rust + Debian + sccache
# https://hub.docker.com/r/smartislav/docker-sccache/dockerfile

FROM rust:1.31.1-stretch as builder

WORKDIR /usr/src/sccache

RUN apt-get update \
 && apt-get install -y libssl-dev --no-install-recommends

# RUN cargo install --features="dist-server,all" sccache --git https://github.com/mozilla/sccache.git --rev 8f295c09cfdd4cff4f4a0c6f0e057979eeb8842d --path .
# Switch to - 0.2.11-alpha.0
# bf4158875d5690294f4d4b2b190097b18c8d0a21
RUN cargo install --features="dist-server,all" sccache --git https://github.com/mozilla/sccache.git --rev 8f295c09cfdd4cff4f4a0c6f0e057979eeb8842d
# RUN cargo install --features="dist-server,all" sccache 

# ==================================================

FROM rust:1.37.0-stretch as build

RUN apt-get update \
 && apt-get install -y libssl1.1 --no-install-recommends \
 && apt-get install bubblewrap

COPY --from=builder /usr/local/cargo/bin/sccache /usr/local/bin/sccache

STOPSIGNAL SIGINT

ENTRYPOINT ["/usr/local/bin/sccache"]
