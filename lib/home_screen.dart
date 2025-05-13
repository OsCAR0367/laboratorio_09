import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Producto> productos = [];
  int nextId = 0;

  @override
  void initState() {
    super.initState();
    _loadProductos();
  }

  Future<void> _loadProductos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('productos');
    if (data != null) {
      setState(() {
        productos = Producto.decode(data);
        nextId = productos.isNotEmpty
            ? productos.map((p) => p.id).reduce((a, b) => a > b ? a : b) + 1
            : 0;
      });
    }
  }

  Future<void> _saveProductos() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = Producto.encode(productos);
    await prefs.setString('productos', encodedData);
  }

  void _addOrEditProducto({Producto? producto}) {
    final nameController = TextEditingController(text: producto?.nombre ?? "");
    final priceController = TextEditingController(
        text: producto?.precio.toString() ?? "");
    final qtyController = TextEditingController(
        text: producto?.cantidad.toString() ?? "");
        
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(producto == null ? 'Agregar Producto' : 'Editar Producto'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Producto'),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Precio'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: qtyController,
              decoration: const InputDecoration(labelText: 'Cantidad'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              final nombre = nameController.text;
              final precio = double.tryParse(priceController.text) ?? 0;
              final cantidad = int.tryParse(qtyController.text) ?? 0;

              if (producto == null) {
                final newProducto = Producto(
                  id: nextId++,
                  nombre: nombre,
                  precio: precio,
                  cantidad: cantidad,
                );
                setState(() => productos.add(newProducto));
              } else {
                final index = productos.indexWhere((p) => p.id == producto.id);
                if (index != -1) {
                  setState(() {
                    productos[index] = Producto(
                      id: producto.id,
                      nombre: nombre,
                      precio: precio,
                      cantidad: cantidad,
                    );
                  });
                }
              }
              _saveProductos();
              Navigator.of(context).pop();
            },
            child: const Text('Guardar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _deleteProducto(int id) {
    setState(() {
      productos.removeWhere((p) => p.id == id);
    });
    _saveProductos();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
      ),
      body: productos.isEmpty
          ? const Center(child: Text('No hay productos'))
          : ListView.builder(
              itemCount: productos.length,
              itemBuilder: (context, index) {
                final producto = productos[index];
                return ListTile(
                  title: Text(producto.nombre),
                  subtitle: Text(
                      'Precio: \$${producto.precio} - Cantidad: ${producto.cantidad}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _addOrEditProducto(producto: producto),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteProducto(producto.id),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditProducto(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

