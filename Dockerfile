FROM alpine:3.8
LABEL source_repository=https://github.com/jknipper/kube-stresscheck

# Build stress from source.
RUN STRESS_VERSION=1.0.4; \
    apk add --no-cache g++ make curl && \
    curl http://deb.debian.org/debian/pool/main/s/stress/stress_${STRESS_VERSION}.orig.tar.gz | tar xz && \
    cd stress-${STRESS_VERSION} && \
    ./configure && make && make install && \
    apk del --purge g++ make curl && rm -rf stress-*

ADD kube-stresscheck /usr/bin/kube-stresscheck
ENTRYPOINT ["/usr/bin/kube-stresscheck"]
