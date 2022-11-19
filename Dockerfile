FROM alpine:3.15

ARG PANDOC_VERSION=2.19.2

RUN apk add --no-cache \
        make \
        bash \
        python2 \
        python3 \
        texlive \
        texlive-luatex \
        texmf-dist-latexextra

RUN ln -s /usr/bin/luahbtex /usr/local/bin/lualatex

RUN luaotfload-tool --update

RUN wget "https://github.com/jgm/pandoc/releases/download/$PANDOC_VERSION/pandoc-$PANDOC_VERSION-linux-amd64.tar.gz" -O /tmp/pandoc.tar.gz
RUN tar -xzf /tmp/pandoc.tar.gz --strip-components 1 -C /usr/local

COPY entry.sh /entry.sh
ENTRYPOINT ["/entry.sh"]
