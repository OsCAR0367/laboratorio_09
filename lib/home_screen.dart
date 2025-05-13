import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Producto> productos = [];
  int contadorId = 0;

  // Controladores para los campos de texto
  final nombreController = TextEditingController();
  final precioController = TextEditingController();
  final cantidadController = TextEditingController();
  final subtotalController = TextEditingController(); // Nuevo controlador, pero será de solo lectura

  @override
  void initState() {
    super.initState();
    _cargarProductos();
  }

  @override
  void dispose() {
    // Liberar los controladores al destruir el widget
    nombreController.dispose();
    precioController.dispose();
    cantidadController.dispose();
    subtotalController.dispose(); // Nuevo controlador
    super.dispose();
  }

  // Cargar productos desde SharedPreferences al iniciar la app
  Future<void> _cargarProductos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? productosString = prefs.getString('productos');
    
    setState(() {
      if (productosString != null) {
        productos = Producto.decode(productosString);
        
        // Encontrar el ID más alto para continuar desde ahí
        if (productos.isNotEmpty) {
          int maxId = productos.map((p) => p.id).reduce((a, b) => a > b ? a : b);
          contadorId = maxId + 1;
        }
      }
    });
  }

  Future<void> _guardarProductos() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = Producto.encode(productos);
    await prefs.setString('productos', encodedData);
  }

  void _calcularSubtotal() {
    if (precioController.text.isNotEmpty && cantidadController.text.isNotEmpty) {
      try {
        final precio = double.parse(precioController.text);
        final cantidad = int.parse(cantidadController.text);
        final subtotal = precio * cantidad;
        
        subtotalController.text = subtotal.toStringAsFixed(2);
      } catch (e) {
        subtotalController.text = '0.00';
      }
    } else {
      subtotalController.text = '0.00';
    }
  }

  // Mostrar el formulario para agregar un producto
  void _mostrarFormularioAgregar() {
    // Limpiar los controladores antes de mostrar el formulario
    nombreController.clear();
    precioController.clear();
    cantidadController.clear();
    subtotalController.clear();
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Agregar Producto'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre del producto'),
                ),
                TextField(
                  controller: precioController,
                  decoration: const InputDecoration(labelText: 'Precio'),
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _calcularSubtotal(), 
                ),
                TextField(
                  controller: cantidadController,
                  decoration: const InputDecoration(labelText: 'Cantidad'),
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _calcularSubtotal(), 
                ),
                TextField(
                  controller: subtotalController,
                  decoration: const InputDecoration(labelText: 'Subtotal'),
                  enabled: false, 
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                nombreController.clear();
                precioController.clear();
                cantidadController.clear();
                subtotalController.clear();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (nombreController.text.isNotEmpty &&
                    precioController.text.isNotEmpty &&
                    cantidadController.text.isNotEmpty) {
                  
                  final nombre = nombreController.text;
                  final precio = double.parse(precioController.text);
                  final cantidad = int.parse(cantidadController.text);
                  final subtotal = precio * cantidad; 
                  
                  setState(() {
                    productos.add(Producto(
                      id: contadorId,
                      nombre: nombre,
                      precio: precio,
                      cantidad: cantidad,
                      subtotal: subtotal, 
                    ));
                    
                    contadorId++;
                  });
                  
                  _guardarProductos();
                  Navigator.of(context).pop();
                  
                  nombreController.clear();
                  precioController.clear();
                  cantidadController.clear();
                  subtotalController.clear();
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  // Editar un producto existente
  void _editarProducto(int index) {
    nombreController.text = productos[index].nombre;
    precioController.text = productos[index].precio.toString();
    cantidadController.text = productos[index].cantidad.toString();
    subtotalController.text = productos[index].subtotal.toStringAsFixed(2);
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Producto'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre del producto'),
                ),
                TextField(
                  controller: precioController,
                  decoration: const InputDecoration(labelText: 'Precio'),
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _calcularSubtotal(), 
                ),
                TextField(
                  controller: cantidadController,
                  decoration: const InputDecoration(labelText: 'Cantidad'),
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _calcularSubtotal(), 
                ),
                TextField(
                  controller: subtotalController,
                  decoration: const InputDecoration(labelText: 'Subtotal'),
                  enabled: false, 
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                nombreController.clear();
                precioController.clear();
                cantidadController.clear();
                subtotalController.clear();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (nombreController.text.isNotEmpty &&
                    precioController.text.isNotEmpty &&
                    cantidadController.text.isNotEmpty) {
                  
                  setState(() {
                    productos[index] = Producto(
                      id: productos[index].id,
                      nombre: nombreController.text,
                      precio: double.parse(precioController.text),
                      cantidad: int.parse(cantidadController.text),
                      subtotal: double.parse(subtotalController.text),
                    );
                  });
                  
                  _guardarProductos();
                  Navigator.of(context).pop();
                  
                  nombreController.clear();
                  precioController.clear();
                  cantidadController.clear();
                  subtotalController.clear();
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  // Eliminar un producto
  void _eliminarProducto(int index) {
    setState(() {
      productos.removeAt(index);
    });
    _guardarProductos();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Productos'),
      ),
      body: productos.isEmpty
          ? const Center(child: Text('No hay productos registrados'))
          : ListView.builder(
              itemCount: productos.length,
              itemBuilder: (context, index) {
                final producto = productos[index];
                return ListTile(
                  title: Text(producto.nombre),
                  subtitle: Text(
                    'Precio: \$${producto.precio.toStringAsFixed(2)} - '
                    'Cantidad: ${producto.cantidad} - '
                    'Subtotal: \$${producto.subtotal.toStringAsFixed(2)}' // Mostrar subtotal
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _editarProducto(index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _eliminarProducto(index),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarFormularioAgregar,
        child: const Icon(Icons.add),
      ),
    );
  }
}