#!/bin/bash

# Crear una network para conectar los dos contenedores si no existe
if [ ! "$(docker network ls -q -f name=^container_network\$)" ]; then
  docker network create container_network
else
  echo "La red container_network ya existe."
fi

# Comprobar si la imagen del proyecto saveToBBDDcontainer está creada
if [[ "$(docker images -q save_to_bbdd_image)" == "" ]]; then
  # Comprobar si la carpeta ./Data_Extraction_Container existe antes de construir la imagen
  if [ -d "./Data_Extraction_Container" ]; then
    # Construir la imagen desde el Dockerfile en ./Data_Extraction_Container
    docker build -t save_to_bbdd_image ./Data_Extraction_Container
  else
    echo "Error: La ruta ./Data_Extraction_Container no se encuentra."
    read -p "Presiona Enter para salir..."
    exit 1
  fi
else
  echo "La imagen save_to_bbdd_image ya está creada."
fi

# Comprobar si el contenedor de MongoDB ya está levantado
if [ ! "$(docker ps -q -f name=bbdd_container)" ]; then
  if [ "$(docker ps -aq -f status=exited -f name=bbdd_container)" ]; then
    # Eliminar el contenedor existente si está en estado "exited"
    docker rm bbdd_container
  fi

  # Comprobar si la carpeta ./BBDDcontainer existe antes de construir la imagen
  if [ -d "./BBDDcontainer" ]; then
    # Construir y levantar el contenedor de MongoDB
    docker build -t bbdd_container ./BBDDcontainer

    docker run -d \
      --name bbdd_container \
      --network container_network \
      -p 27017:27017 \
      bbdd_container
  else
    echo "Error: La ruta ./BBDDcontainer no se encuentra."
    read -p "Presiona Enter para salir..."
    exit 1
  fi
else
  echo "El contenedor bbdd_container ya está en funcionamiento."
fi

# Comprobar si el contenedor save_to_bbdd_container ya está levantado
if [ ! "$(docker ps -q -f name=save_to_bbdd_container)" ]; then
  if [ "$(docker ps -aq -f status=exited -f name=save_to_bbdd_container)" ]; then
    # Eliminar el contenedor existente si está en estado "exited"
    docker rm save_to_bbdd_container
  fi

  # Levantar el contenedor save_to_bbdd_container desde la imagen save_to_bbdd_image
  docker run -d \
    --name save_to_bbdd_container \
    --network container_network \
    save_to_bbdd_image
else
  echo "El contenedor save_to_bbdd_container ya está en funcionamiento."
fi

# Mostrar los logs del contenedor save_to_bbdd_container
docker logs -f save_to_bbdd_container

# Pausar para que puedas ver los resultados
read -p "Presiona Enter para salir..."
