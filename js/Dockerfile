FROM node:20-alpine3.20 AS js-auth-server
WORKDIR /app

COPY ./auth-server/*.json ./auth-server/
COPY ./*.json ./
COPY ./yarn.lock .

RUN corepack enable

RUN yarn install
COPY ./auth-server/. ./auth-server
CMD ["yarn", "start-auth"]
EXPOSE 3000