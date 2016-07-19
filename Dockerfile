FROM publicisworldwide/node:5.12

USER root
RUN yum install git -y

USER $CONTAINER_USER

# Create app directory
RUN mkdir -p /home/$CONTAINER_USER/app
WORKDIR /home/$CONTAINER_USER/app

# Install app dependencies
COPY package.json /home/$CONTAINER_USER/app
COPY bower.json /home/$CONTAINER_USER/app
RUN npm install

# Bundle app source
COPY . /home/$CONTAINER_USER/app

VOLUME /home/$CONTAINER_USER/app/repositories

EXPOSE 3000
ENTRYPOINT [ "npm", "start" ]
