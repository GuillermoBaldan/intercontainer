#!/bin/bash

# Crear una network para conectar los dos contenedores
docker network create container_network

# Construir y levantar el contenedor de MongoDB
docker build -t bbdd_container ./BBDDcontainer

docker run -d \
  --name bbdd_container \
  --network container_network \
  -p 27017:27017 \
  bbdd_container

# Construir y levantar el contenedor de extracción de datos
docker build -t data_extraction_container ./Data_Extraction_Container

docker run -d \
  --name data_extraction_container \
  --network container_network \
  data_extraction_container
