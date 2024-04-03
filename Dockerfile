# syntax=docker/dockerfile:1.5
FROM alpine AS build-layer
RUN apk --no-cache add gcc musl-dev make upx || apk --no-cache add gcc musl-dev make
COPY src/http-hello.c src/hello.h src/httpserver.h /build/
WORKDIR /build
RUN gcc -o http-hello -s -O2 -static http-hello.c && strip -x http-hello
RUN which upx && upx http-hello || true
WORKDIR /dist
RUN cp /build/http-hello /dist/http-hello

FROM scratch
COPY --from=build-layer /dist/ /
USER 50000:50000
EXPOSE 8000
ENTRYPOINT [ "/http-hello" ]
