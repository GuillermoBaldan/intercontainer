FROM mongo:latest

# Crear un volumen para almacenar los datos de MongoDB de manera persistente
VOLUME /data/db

# Establecer la base de datos que se utilizará
ENV MONGO_INITDB_DATABASE=carsDB

# Puerto por defecto de MongoDB
EXPOSE 27017

# Copiar archivo de configuración si se requiere (opcional)
# COPY mongod.conf /etc/mongod.conf

# Comando para iniciar MongoDB
CMD ["mongod"]
