FROM node:latest

# Crear directorio de la aplicación
WORKDIR /app

# Copiar el archivo package.json y package-lock.json
COPY package*.json ./

# Instalar las dependencias
RUN npm install

# Copiar el resto de la aplicación
COPY . .

# Exponer el puerto necesario (si aplica)
EXPOSE 3000

# Comando para ejecutar el script de extracción de datos
CMD ["node", "SaveToBBDDcontainer/saveDataToMongoContainer.js"]
