FROM node:22

WORKDIR /localize

COPY package*.json ./

RUN npm ci --only=production

COPY . .

EXPOSE 8080

CMD [ "node", "index.js" ]