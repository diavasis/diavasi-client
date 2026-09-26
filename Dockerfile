FROM rust:1.88-bookworm
WORKDIR /src
COPY . /src
RUN cargo build --release --bin diavasi-consume
RUN chmod +x /src/wait-ca.sh
CMD ["/bin/sh", "-c", "/src/wait-ca.sh && /src/target/release/diavasi-consume --addr \"$DIAVASI_DATA_ADDR\" --ca \"$DIAVASI_CA\" --token \"$DIAVASI_API_TOKEN\" --group demo --consumer rust --total 8"]
