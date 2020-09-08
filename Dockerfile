FROM node:14.9.0

# ignore DL3009 Delete the apt-get lists after installing something
# hadolint ignore=DL3009
RUN apt-get update
# ignore DL3005 Do not use apt-get upgrade or dist-upgrade
# hadolint ignore=DL3005
RUN apt-get upgrade -y
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app

#RUN npm install -g contentful-cli

COPY app/package.json .
RUN npm install

COPY app/. .

RUN npm run build

# Installing serve to propose production ready deployment
RUN npm install -g serve

USER node
EXPOSE 3000

# Running serve -s build -l 3000 to expose production ready react-js application
CMD ["serve", "-s", "build", "-l", "3000"]
