#Stage 1 Creating angular build(dist folder). 
#as node means you are creating an alias for this stage to be accessed in the future stages
FROM node:alpine as node
ARG env="prod"
LABEL author="Ramya"
RUN mkdir /app
WORKDIR /app
# node is the base image from which Docker will include all functionality into the image we will be crearting
# Its like a parent class from which we are inheriting all features into the child class

COPY package.json package-lock.json ./
RUN npm cache clean --force
RUN npm install
COPY . .
COPY ./src/environments/environment.${env}.ts  ./src/environments/environment.prod.ts
RUN npm run build

#Stage 2

FROM nginx:alpine

#caching files
VOLUME /var/cache/nginx 

#Now I need to access the dist folder from the previous stage. 
# I copy the dist folder into the folder that nginx uses to refer static files.
COPY --from=node /app/dist/docker-test /usr/share/nginx/html
# to replace the default nginx config file with our config file. In our config file we
# have added an additional check. When we are routing to other components with different paths,
# nginx might think its a server side path and return 404. In such cases we instruct nginx to 
# redirect to index.html file. This is very important
COPY ./config/nginx.config /etc/nginx/conf.d/default.conf


#RUN docker build . -t angular-image-prod --build-arg env="prod"
#RUN docker build . -t angular-image-dev --build-arg env="development"

#RUN docker run -dp 4200:80 -v ${PWD}/dist:/usr/share/nginx/html angular-image
#d indicates detached mode and p means publish
#

#RUN docker run -dp 8800:80 -it angular-image-dev
#RUN docker run -dp 80:80 -it angular-image-prod

#open http://192.168.99.100:8800/ in browser to load angular app