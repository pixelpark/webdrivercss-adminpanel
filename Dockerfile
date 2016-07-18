FROM publicisworldwide/node:5.12

USER $CONTAINER_USER

# Create app directory
RUN mkdir -p /home/$CONTAINER_USER/app
WORKDIR /home/$CONTAINER_USER/app

# Install app dependencies
COPY package.json /home/$CONTAINER_USER/app
RUN npm install

# Bundle app source
COPY . /home/$CONTAINER_USER/app

EXPOSE 3000
ENTRYPOINT [ "npm", "start" ]
