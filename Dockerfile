FROM alpine

RUN apk add --no-cache git
RUN apk add --no-cache  build-base
RUN apk add --no-cache m4 ocaml-camlp4-dev zlib-dev bzip2-dev gnu-libiconv-dev  gd-dev
RUN git clone https://github.com/ygrek/mldonkey.git

WORKDIR /mldonkey
RUN ls -la

RUN /usr/bin/git checkout tags/release-3-2-1
RUN ./configure --prefix=/app  --enable-iconv --enable-gd --enable-bzip2 --enable-magic --enable-largefile --enable-checks
RUN gmake
RUN make tests
RUN make install


FROM alpine
RUN apk update
RUN apk add libgd
RUN apk add --no-cache libbz2
RUN apk add --no-cache libmagic
RUN apk add --no-cache gnu-libiconv
RUN apk add --no-cache libstdc++
RUN apk add --no-cache libgcc
RUN adduser -S -u 586 -h /conf mldonkey -s /bin/sh
COPY --from=0 /app /app

USER mldonkey
WORKDIR /conf

CMD ["/app/bin/mldonkey", "-allowed_ips", "0.0.0.0/0"]