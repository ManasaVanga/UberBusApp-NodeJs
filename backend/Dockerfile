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
#RUN npm install react-scripts@4.0.0 --silent

# create build
COPY . .
RUN npm run build

#########
# FINAL #
#########

# base image
FROM nginx

# update nginx conf
#RUN rm -rf /etc/nginx/conf.d
#COPY conf /etc/nginx

# copy static files
COPY --from=builder /app/build /usr/share/nginx/html

# expose port
EXPOSE 80
