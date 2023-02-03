FROM alpine:3 AS build

RUN apk update && apk add build-base linux-headers perl

WORKDIR /build
ADD Makefile /build/
ADD ./deps /build/deps/
ADD ./src /build/src/

RUN make

FROM alpine:3 AS final

RUN apk update && apk add libgcc
COPY --from=build /build/wrk /usr/bin/wrk

ENTRYPOINT ["/usr/bin/wrk"]
ARG COMMIT_ID
ARG VERSION
ENV VERSION="${VERSION}"

LABEL org.opencontainers.image.title="NyanKiyoshi/wrk" \
      org.opencontainers.image.description="Modern HTTP benchmarking tool" \
      org.opencontainers.image.url="https://github.com/wg/wrk/" \
      org.opencontainers.image.source="https://github.com/NyanKiyoshi/wrk" \
      org.opencontainers.image.revision="$COMMIT_ID" \
      org.opencontainers.image.version="$VERSION" \
      org.opencontainers.image.authors="wg/wrk (https://github.com/cloudmercato/wrk)" \
      org.opencontainers.image.licenses="Apache 2.0"
