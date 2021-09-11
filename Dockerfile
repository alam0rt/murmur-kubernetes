ARG MURMUR_VERSION=1.3.4
FROM alpine as setup
ARG MURMUR_VERSION

WORKDIR /tmp

ADD https://github.com/mumble-voip/mumble/releases/download/${MURMUR_VERSION}/murmur-static_x86-${MURMUR_VERSION}.tar.bz2 murmur-static_x86-${MURMUR_VERSION}.tar.bz2

RUN tar -xvf murmur-static_x86-${MURMUR_VERSION}.tar.bz2

RUN mkdir /murmur && chown 1337:1337 /murmur

FROM scratch
ARG MURMUR_VERSION

COPY --from=setup /etc/passwd /etc/group /etc/
USER 1337

COPY --chown=1337:1337 --from=setup /murmur /murmur

WORKDIR /murmur

COPY --chown=1337:1337 --from=setup /tmp/murmur-static_x86-${MURMUR_VERSION}/murmur.x86 /bin/murmur

EXPOSE 64738/tcp
EXPOSE 64738/udp

ENTRYPOINT [ "/bin/murmur", "-fg"]
