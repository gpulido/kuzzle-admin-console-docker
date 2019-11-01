FROM node:alpine as temp

RUN apk add --no-cache curl

RUN LOCATION=$(curl -s https://api.github.com/repos/kuzzleio/kuzzle-admin-console/releases/latest \
    | grep "tag_name" \
    | awk '{print "https://github.com/kuzzleio/kuzzle-admin-console/archive/" substr($2, 2, length($2)-3) ".tar.gz"}') \
    ; TAG_NAME=$(curl -s https://api.github.com/repos/kuzzleio/kuzzle-admin-console/releases/latest \
    | grep "tag_name" \
    | awk '{print substr($2, 2, length($2)-3)}') \
    ; curl -L -o kuzzle-admin-console.tar.gz $LOCATION \
    ; tar xvfz kuzzle-admin-console.tar.gz \
    ; mv kuzzle-admin-console-${TAG_NAME} kuzzle-admin-console

RUN apk add --no-cache git && \
    apk add --no-cache python2 && \
    apk add --no-cache g++ && \
    apk add --no-cache make

WORKDIR ./kuzzle-admin-console
RUN npm install
RUN npm run build 

FROM abhin4v/hastatic:latest

COPY --from=temp ./kuzzle-admin-console/dist /opt/kuzzle_admin_console
WORKDIR /opt/kuzzle_admin_console
CMD ["/usr/bin/hastatic"]