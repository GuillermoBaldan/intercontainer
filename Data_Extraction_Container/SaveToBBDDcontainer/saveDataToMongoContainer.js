const mongoose = require('mongoose');
const fs = require('fs');
const path = require('path');
const Car = require('../Models/Car');

// Ruta al archivo JSON con los datos de los coches
const dataPath = path.join(__dirname, '../Data/cars.json');

// Conexión a la base de datos MongoDB
mongoose.connect('mongodb://bbdd_container:27017/carsDB', {
  useNewUrlParser: true,
  useUnifiedTopology: true
}).then(() => {
  console.log('Conectado a MongoDB');

  // Leer el archivo JSON
  fs.readFile(dataPath, 'utf8', (err, data) => {
    if (err) {
      console.error('Error al leer el archivo JSON:', err);
      process.exit(1);
    }

    // Parsear el archivo JSON
    const cars = JSON.parse(data);

    // Guardar los datos en la base de datos
    Car.insertMany(cars)
      .then(() => {
        console.log('Datos guardados correctamente en MongoDB');
        mongoose.connection.close();
      })
      .catch((error) => {
        console.error('Error al guardar los datos en MongoDB:', error);
        mongoose.connection.close();
      });
  });
}).catch((error) => {
  console.error('Error al conectar a MongoDB:', error);
  process.exit(1);
});
