###########
# BUILDER #
###########

# pull official base image
FROM node:15.2.0-alpine as builder

# set working directory
WORKDIR /app

# add /usr/src/app/node_modules/.bin to $PATH
ENV PATH /app/node_modules/.bin:$PATH

# Installing dependencies
COPY package*.json ./
RUN npm install

# Copying source files
COPY . .

# Building app
RUN npm run build

CMD ["npm", "start"]
