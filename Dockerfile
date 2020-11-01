# Credit to https://github.com/badouralix/dockerfiles/blob/master/deplacement-covid-19/Dockerfile

FROM node:alpine AS build

# Install utils and chromium because why not ( postbuild and react-snap )
RUN apk add --no-cache chromium g++ git jq make moreutils python3

COPY . /app
WORKDIR /app

# Yolo patch package.json to run build in docker
RUN cat package.json | jq '.reactSnap.puppeteerExecutablePath="/usr/bin/chromium-browser" | .reactSnap.puppeteerArgs=["--no-sandbox", "--disable-dev-shm-usage"]' | sponge package.json

ENV PUBLIC_URL /
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true
RUN yarn install
RUN VERSION=`git rev-parse --short HEAD` npm run build:dev

EXPOSE 5000

CMD npx serve dist
