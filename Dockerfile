FROM node:20-alpine as development
#imagen comom development
WORKDIR /app
#mismo directorio de trabajo

RUN apk update && apk add --no-cache \
    chromium \
    nss \
    freetype \
    ca-certificates \
    ttf-freefont \
    git
    #instalar chrome,documentación,necesario para utilizar angular 

ENV CHROME_BIN=/usr/bin/chromium-browser
ENV LIGHTHOUSE_CHROMIUM_PATH=/usr/bin/chromium-browser
#apuntar a la variables de chrome

ENV PATH="/home/appuser/.npm-global/bin:${PATH}"
RUN npm install -g @angular/cli
#instalamos nuevamente angular cli

COPY package*.json ./
RUN npm install
#copiamos nuestro package en el directorio virtualizando para realizar un npm y así instalar las dependencias necesarias para el local

COPY . .
EXPOSE 4200
#Copiamos nustro directorio de trabajo(. .),angular trabaja en el puerto 4200(EXPOSE significa que uniremos nuestro puerto 4200 con el de la maquina virtualizada)
CMD ["ng","serve","=`--host","0.0.0.0","--poll","2000"]
#Correremos el ng serve para levantar

#Para el build es hace lo mismo pero solamente un ng a producción
FROM node:16 as build

WORKDIR /app

RUN npm ionstall -g @angular/cli

COPY package*.json ./

RUN npm install

COPY . . 

RUN ng build --prod