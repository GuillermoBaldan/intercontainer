# Descripción del proyecto
Se trata de un proyecto de pruebas para crear un contendor con una BBDD de MongoDB y otro contenedor que lee unos ficheros json que se encuentran en su interior y los guarda en el contendor de la BBDD.

Para lograr que los scripts en un contenedor lean los ficheros `.json` y los guarden en una base de datos que está en otro contenedor, puedes seguir estos pasos:

1. **Conexión entre contenedores**:
   - Ambos contenedores deben poder comunicarse entre sí. Para esto, debes asegurarte de que ambos están en la misma red Docker.
   - Crea una red Docker:

     ```bash
     docker network create my_network
     ```

   - Conecta ambos contenedores a esa red al momento de crearlos o añádelos a la red existente:

     ```bash
     docker network connect my_network container1
     docker network connect my_network container2
     ```

2. **Configuración del Contenedor de Base de Datos**:
   - Asegúrate de exponer el puerto de la base de datos para que el otro contenedor pueda conectarse. Por ejemplo, si estás usando MongoDB, deberías exponer el puerto `27017`:

     ```bash
     docker run -d --name mongodb --network my_network -p 27017:27017 mongo
     ```

3. **Configuración de los Scripts**:
   - Los scripts en el contenedor que lee los ficheros `.json` deben tener la configuración necesaria para conectarse a la base de datos. Asegúrate de que la URL de conexión apunta al nombre del contenedor de la base de datos en la red Docker.
   - Por ejemplo, si estás usando Node.js con MongoDB, la URL de conexión podría ser algo como:

     ```javascript
     const mongoose = require('mongoose');
     const dbURI = 'mongodb://mongodb:27017/flightsDB'; // 'mongodb' es el nombre del contenedor de la BBDD

     mongoose.connect(dbURI, { useNewUrlParser: true, useUnifiedTopology: true })
       .then(() => console.log('Conectado a MongoDB'))
       .catch(err => console.log('Error al conectar a MongoDB:', err));
     ```

4. **Docker Compose (opcional)**:
   - Puedes simplificar la gestión de estos contenedores usando `docker-compose`. Un archivo `docker-compose.yml` te permitiría configurar los servicios y la red automáticamente. Un ejemplo básico:

     ```yaml
     version: '3'
     services:
       app:
         image: node:latest
         container_name: app_container
         volumes:
           - ./scripts:/app/scripts
         working_dir: /app
         command: node scripts/your_script.js
         networks:
           - my_network
       mongodb:
         image: mongo
         container_name: mongodb_container
         ports:
           - "27017:27017"
         networks:
           - my_network

     networks:
       my_network:
         driver: bridge
     ```

   - Con este `docker-compose.yml`, podrías levantar ambos contenedores y conectarlos a la misma red con solo ejecutar:

     ```bash
     docker-compose up
     ```

Esto permitirá que el contenedor donde se ejecutan los scripts pueda conectarse al contenedor de la base de datos para guardar los datos que lee de los archivos `.json`. Asegúrate de configurar adecuadamente las variables de entorno para las credenciales y los detalles de conexión.