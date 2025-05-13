# Laboratorio 09 - Gestión de Productos

## Descripción
Una aplicación móvil desarrollada con Flutter que permite gestionar un inventario de productos. Implementa operaciones CRUD (Crear, Leer, Actualizar, Eliminar) y utiliza SharedPreferences para persistencia de datos local.

## Características
- **Almacenamiento persistente**: Los productos se guardan localmente mediante SharedPreferences
- **Gestión completa de productos**: Crear, visualizar, editar y eliminar productos
- **Cálculo automático**: El subtotal se calcula automáticamente (precio × cantidad)
- **Interfaz intuitiva**: Diseño limpio con Material Design
- **Formularios modales**: Interacción mediante diálogos emergentes


## Estructura del proyecto
```
laboratorio_09/
├── lib/
│   ├── main.dart           # Punto de entrada de la aplicación
│   ├── home_screen.dart    # Pantalla principal con la lista de productos
│   └── models/
│       └── product.dart    # Modelo de datos para productos
├── pubspec.yaml            # Dependencias del proyecto
└── README.md               # Este archivo
```

## Tecnologías utilizadas
- **Flutter**: Framework para desarrollo multiplataforma
- **Dart**: Lenguaje de programación
- **SharedPreferences**: API para almacenamiento de datos clave-valor
- **Material Design**: Sistema de diseño de interfaces

## Requisitos previos
- Flutter SDK (^3.7.2)
- Dart SDK (^3.0.0)
- Un emulador o dispositivo físico para ejecutar la aplicación

## Instalación
1. Clone el repositorio:
   ```
   git clone https://github.com/usuario/laboratorio_09.git
   ```

2. Navegue al directorio del proyecto:
   ```
   cd laboratorio_09
   ```

3. Instale las dependencias:
   ```
   flutter pub get
   ```

4. Ejecute la aplicación:
   ```
   flutter run
   ```

## Uso
1. La pantalla principal muestra la lista de productos (o un mensaje si no hay ninguno)
2. Pulse el botón flotante (+) para añadir un nuevo producto
3. Complete el formulario con nombre, precio y cantidad
4. El subtotal se calculará automáticamente
5. Para editar o eliminar un producto, utilice los iconos correspondientes en cada entrada

## Dependencias
- flutter: ^3.7.2
- cupertino_icons: ^1.0.8
- shared_preferences: ^2.2.2

## Autor
[Tu Nombre]

## Licencia
Este proyecto está bajo la Licencia MIT - vea el archivo LICENSE.md para más detalles.