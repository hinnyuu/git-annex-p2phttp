FROM alpine:3.21
RUN apk add --no-cache git git-annex curl
RUN adduser -D -h /home/annex annex
USER annex
WORKDIR /home/annex
VOLUME /annex-data /git-repos
EXPOSE 9417
CMD ["git-annex", "p2phttp", "--directory=/git-repos", "--jobs=4", "--bind=0.0.0.0"]