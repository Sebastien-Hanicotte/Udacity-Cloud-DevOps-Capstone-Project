FROM node:14.9.0

RUN apt-get update
RUN apt-get upgrade -y

WORKDIR /app

#RUN npm install -g contentful-cli

COPY app/package.json .
RUN npm install

COPY app/. .

RUN npm run build

USER node
EXPOSE 3000

CMD ["npm", "run", "start"]
