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
# Based on the ARG env we pass in the docker build command, we swap the environment files so that the correct env file can be accessed
# in the application. This is useful if we are deploying the same build to all environments but the env related information eg: backend
#url differs between the environments. Since we are using prod env in the ng build command, the environment.prod.ts will be used by the application
#But when deploying to dev env, we require the dev specific env file to be accessed by the application. So we pass the correct env to the docker build command. We copy
# that env's env file to the environment.prod.ts so that the correct env config info is available to the application
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

# Use the below docker build and run commands. We are creating 2 images below: angular-image-prod and angular-image-dev
# We want to load the prod config in the environment.prod.ts when running angular-image-prod
#We want to load the dev config in the environment.prod.ts when running angular-image-dev
#The environment.prod.ts will only be used because we are running ng build using prod configuration.
# If we are deploying different builds to different environments, there is no need to copy the desired environment file to environment.prod.ts i.e line 15
# because the env we provide in the ng build --configuration=env command will automatically be used to allocate the correct the env file for the application.
#When we deploy the same prod build to all env, we need to execute line 15 to ensure that the correct config detail is used by the application

#RUN docker build . -t angular-image-prod --build-arg env="prod"
#RUN docker build . -t angular-image-dev --build-arg env="development"

#RUN docker run -dp 8800:80 -it angular-image-dev
#RUN docker run -dp 80:80 -it angular-image-prod

#open http://192.168.99.100:8800/ in browser to load angular app

#We are not using the below command anywhere
#RUN docker run -dp 4200:80 -v ${PWD}/dist:/usr/share/nginx/html angular-image
#d indicates detached mode and p means publish
