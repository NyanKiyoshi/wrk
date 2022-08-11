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
