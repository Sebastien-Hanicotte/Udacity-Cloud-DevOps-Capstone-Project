FROM node:14.9.0

WORKDIR /app

#RUN npm install -g contentful-cli

COPY app/package.json .
RUN npm install

COPY app/. .

RUN npm run build

USER node
EXPOSE 3000

CMD ["npm", "run", "start"]
