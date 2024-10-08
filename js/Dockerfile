FROM node:22-alpine3.19 AS js-auth-server
WORKDIR /app

ENV YARN_NODE_LINKER=node-modules
COPY ./auth-server/package.json ./auth-server/
COPY ./package.json ./

COPY ./tsconfig.base.json ./

RUN corepack enable
RUN yarn install

COPY ./auth-server/ ./auth-server/

CMD ["yarn", "start-auth"]

EXPOSE 3000
