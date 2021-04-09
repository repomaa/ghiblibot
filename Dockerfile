FROM crystallang/crystal:0.35.1-alpine AS build

WORKDIR /app
COPY shard.yml shard.lock ./
RUN shards install --production
COPY src ./src
RUN shards build --release --production --static

FROM scratch AS final-image
CMD ["/usr/local/bin/ghiblibot"]
COPY --from=build /etc/ssl/certs /etc/ssl/certs
COPY --from=build /app/bin/ghiblibot /usr/local/bin/
