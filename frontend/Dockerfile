# Name the node stage "builder"
FROM node:15.2.0-alpine AS builder
# Set working directory
WORKDIR /app
# Copy all files from current directory to working dir in image
COPY . .

ENV REACT_APP_SERVER_URL http://localhost:3001/api

# install node modules and build assets
RUN npm install
RUN npm run build

# nginx state for serving content
FROM nginx:stable-alpine

# Copy static assets from builder stage
COPY --from=builder /app/build /usr/share/nginx/html
# COPY --from=builder /app/nginx.conf /etc/nginx/default.conf

EXPOSE 80
ENTRYPOINT ["nginx", "-g", "daemon off;"]




# ###########
# # BUILDER #
# ###########

# # pull official base image
# FROM node:15.2.0-alpine as builder

# # set working directory
# WORKDIR /app

# # add /usr/src/app/node_modules/.bin to $PATH
# ENV PATH /app/node_modules/.bin:$PATH

# # install and cache app dependencies
# COPY package.json .
# COPY package-lock.json .
# RUN npm ci
# #RUN npm install react-scripts@4.0.0 --silent

# # set environment variables
# ARG REACT_APP_SERVER_URL
# ENV REACT_APP_SERVER_URL $REACT_APP_SERVER_URL
# ARG NODE_ENV
# ENV NODE_ENV $NODE_ENV

# # create build
# COPY . .
# RUN npm run build

# #########
# # FINAL #
# #########

# # base image
# FROM nginx

# # update nginx conf
# #RUN rm -rf /etc/nginx/conf.d
# #COPY conf /etc/nginx

# # copy static files
# COPY --from=builder /app/build /usr/share/nginx/html

# # expose port
# EXPOSE 80
