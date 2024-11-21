# Utilizar una imagen base de Node.js
FROM node:alpine

# Establecer el directorio de trabajo
WORKDIR /app

# Copiar package.json y package-lock.json para instalar dependencias
COPY package*.json ./

# Instalar las dependencias
RUN npm install

# Copiar el resto del código de la aplicación
COPY . .

# Comando para ejecutar el script
CMD ["node", "SaveToBBDDcontainer/saveDataToMongoContainer.js"]
