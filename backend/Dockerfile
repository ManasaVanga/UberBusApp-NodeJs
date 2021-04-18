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
COPY . .

# RUN npm install pm2 -g
# RUN npm install --save-dev dotenv
RUN npm i
#RUN npm install react-scripts@4.0.0 --silent

CMD ["npm", "start"]