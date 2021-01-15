FROM golang:1.11 AS builder1

WORKDIR /go/src/github.com/jknipper/kube-stresscheck
#ENV CGO_ENABLED=0
ADD main.go .
RUN go build -v -o /kube-stresscheck

FROM ubuntu:latest as builder2
WORKDIR /tmp
RUN STRESS_VERSION=1.0.4; \
    apt-get update && \
    apt-get install -y build-essential curl && \
    curl http://deb.debian.org/debian/pool/main/s/stress/stress_${STRESS_VERSION}.orig.tar.gz | tar xz && \
    cd stress-${STRESS_VERSION} && \
    ./configure && make && make install && \
    chmod +x /usr/local/bin/stress

FROM ubuntu:latest
LABEL source_repository=https://github.com/jknipper/kube-stresscheck
COPY --from=builder1 /kube-stresscheck /usr/local/bin/kube-stresscheck
COPY --from=builder2 /usr/local/bin/stress /usr/local/bin/stress
CMD ["/usr/local/bin/kube-stresscheck"]
