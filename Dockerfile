FROM node:lts-alpine AS builder
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY tsconfig*.json ./
COPY app src
RUN npm run build

FROM node:lts-alpine
ENV NODE_ENV=production
WORKDIR /usr/src/app
COPY package*.json ./
RUN sed -i "s/build\/app\/index.js/index.js/g" package.json
RUN npm install --production --silent
COPY --from=builder /usr/src/app/build .
RUN chown -R node /usr/src/app
USER node
CMD ["node", "index.js"]
