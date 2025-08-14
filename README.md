# The Book Nook

## Comienzo del proyecto

Este proyecto nació como una **aplicación de tienda de libros** para aprender y practicar la integración de **Flutter** en el frontend con **Node.js** en el backend. La idea principal era crear una app multiplataforma que permita gestionar libros y usuarios con funcionalidades en tiempo real usando una base de datos local.

## Estructura del proyecto

- **backend/**:  
  Contiene el servidor en Node.js con rutas, controladores, modelos y base de datos local en formato JSON.  
  Archivos principales:  
  - `index.js` → punto de entrada del servidor  
  - `controllers/` → controladores de autenticación y libros  
  - `models/` → repositorios de usuario y libro  
  - `routes/` → rutas para auth, libros y perfil  

- **frontend/**:  
  Aplicación Flutter con interfaz móvil multiplataforma.  
  Archivos principales:  
  - `lib/` → modelos, providers, pantallas y widgets  
  - `assets/` → íconos e imágenes  
  - `android/`, `ios/`, `web/`, `windows/`, `macos/`, `linux/` → proyectos por plataforma  

## Tecnologías usadas

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Node.js](https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=node.js&logoColor=white)
![Express](https://img.shields.io/badge/Express-000000?style=for-the-badge&logo=express&logoColor=white)
![JSON](https://img.shields.io/badge/JSON-000000?style=for-the-badge&logo=json&logoColor=white)
![Provider](https://img.shields.io/badge/Provider-42A5F5?style=for-the-badge&logo=flutter&logoColor=white)
