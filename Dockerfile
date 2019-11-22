FROM node:alpine as temp

RUN apk add --no-cache curl

RUN apk add --no-cache git && \
    apk add --no-cache python2 && \
    apk add --no-cache g++ && \
    apk add --no-cache make

RUN git clone --branch 2.5.3 https://github.com/kuzzleio/kuzzle-admin-console

WORKDIR ./kuzzle-admin-console
RUN npm install
RUN npm run build 

FROM abhin4v/hastatic:latest

COPY --from=temp ./kuzzle-admin-console/dist /opt/kuzzle_admin_console
WORKDIR /opt/kuzzle_admin_console
CMD ["/usr/bin/hastatic"]
