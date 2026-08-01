FROM alpine:3.24 AS builder

ARG CGIT_VERSION=1.3.1

RUN apk add --no-cache \
    autoconf ca-certificates curl gcc git libzip-dev \
    linux-headers lua5.4-dev make musl-dev openssl-dev perl zlib-dev

WORKDIR /src
RUN curl -fsSL "https://git.zx2c4.com/cgit/snapshot/cgit-${CGIT_VERSION}.tar.xz" | tar xJ
WORKDIR /src/cgit-${CGIT_VERSION}
RUN make get-git

RUN cat > cgit.conf <<'EOF'
CGIT_SCRIPT_PATH = /usr/share/webapps/cgit
CGIT_DATA_PATH = /usr/share/webapps/cgit
CGIT_CONFIG = /etc/cgitrc
CACHE_ROOT = /var/cache/cgit
prefix = /usr
LUA_PKGCONFIG = lua5.4
NO_REGEX = NeedsStartEnd
NO_GETTEXT = YesPlease
EOF

RUN make -j"$(nproc)" NO_REGEX=NeedsStartEnd NO_GETTEXT=YesPlease \
    && make install DESTDIR=/build-output NO_REGEX=NeedsStartEnd NO_GETTEXT=YesPlease


# ---

FROM nginx:1.28-alpine

ARG CGIT_VERSION=1.3.1
ENV CGIT_VERSION=${CGIT_VERSION}

ENV CGIT_TITLE="CGit" \
    CGIT_DESC="The hyperfast web frontend for Git repositories" \
    CGIT_WORKERS=1

RUN apk add --no-cache \
    ca-certificates fcgiwrap git libzip lua5.4-libs openssl \
    py3-docutils py3-markdown py3-pygments python3 \
    spawn-fcgi tzdata xz zlib \
    && rm -rf /var/cache/apk/* /tmp/*

COPY --from=builder /build-output/usr/share/webapps/cgit/ /usr/share/webapps/cgit/
COPY --from=builder /build-output/usr/lib/cgit/ /usr/lib/cgit/
RUN sed -i "s/style='pastie'/style='monokai'/g" /usr/lib/cgit/filters/html-converters/md2html
COPY cgit/hljs/ /usr/share/webapps/cgit/cgit-css/

COPY cgit/cgit.conf /tmp/cgitrc.tmpl
COPY cgit/theme.css /usr/share/webapps/cgit/cgit-css/theme.css
COPY cgit/head-include.html /usr/share/webapps/cgit/head-include.html
COPY docker-entrypoint.sh /
COPY nginx/nginx.conf /etc/nginx/nginx.conf

RUN chmod +x /docker-entrypoint.sh \
    && mkdir -p /var/cache/cgit /srv/git \
    && chown -R nginx:nginx /var/cache/cgit /usr/share/webapps/cgit /tmp/cgitrc.tmpl /etc/nginx

USER nginx

ENTRYPOINT [ "/docker-entrypoint.sh" ]
EXPOSE 8080
STOPSIGNAL SIGQUIT
CMD [ "nginx", "-g", "daemon off;" ]

LABEL org.opencontainers.image.title="cgit-container" \
    org.opencontainers.image.description="CGit ${CGIT_VERSION} built from source on Alpine + Nginx" \
    org.opencontainers.image.version="${CGIT_VERSION}" \
    org.opencontainers.image.source="https://github.com/kushwanth/cgit-container"
