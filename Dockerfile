FROM alpine:3.7 as temp
RUN apk add --no-cache curl

RUN curl -s https://dl.kuzzle.io/admin-console/kuzzle-admin-console.tar.gz | tar xvz -C .

FROM abhin4v/hastatic:latest

COPY --from=temp ./dist /opt/kuzzle_admin_console
WORKDIR /opt/kuzzle_admin_console
CMD ["/usr/bin/hastatic"]