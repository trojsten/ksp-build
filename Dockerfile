FROM alpine:3.18

ARG PANDOC_VERSION=3.1.9

RUN apk add --no-cache \
        bash \
        make \
        python3 \
        texlive \               # deprecated for tectonic
        texlive-luatex \        # deprecated for tectonic
        texmf-dist-latexextra \ # deprecated for tectonic
        tectonic

RUN ln -s /usr/bin/luahbtex /usr/local/bin/lualatex # deprecated for tectonic

RUN luaotfload-tool --update # deprecated for tectonic

RUN wget "https://github.com/jgm/pandoc/releases/download/$PANDOC_VERSION/pandoc-$PANDOC_VERSION-linux-amd64.tar.gz" -O /tmp/pandoc.tar.gz
RUN tar -xzf /tmp/pandoc.tar.gz --strip-components 1 -C /usr/local

COPY entry.sh /entry.sh
ENTRYPOINT ["/entry.sh"]
