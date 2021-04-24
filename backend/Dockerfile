###########
# BUILDER #
###########

# pull official base image
FROM node:15.2.0-alpine as builder

# set working directory
WORKDIR /app

# add /usr/src/app/node_modules/.bin to $PATH
ENV PATH /app/node_modules/.bin:$PATH

# install and cache app dependencies
COPY package.json .
COPY package-lock.json .
RUN npm ci

# create build
COPY . .
RUN npm run build

CMD ["npm", "start"]
