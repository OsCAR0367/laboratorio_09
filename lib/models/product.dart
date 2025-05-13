import 'dart:convert';

class Producto {
  final int id;
  final String nombre;
  final double precio;
  final int cantidad;
  final double subtotal; 

  Producto({
    required this.id,
    required this.nombre, 
    required this.precio, 
    required this.cantidad,
    required this.subtotal, 
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'],
      nombre: json['nombre'],
      precio: json['precio'],
      cantidad: json['cantidad'],
      subtotal: json['subtotal'] ?? (json['precio'] * json['cantidad']), 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'precio': precio,
      'cantidad': cantidad,
      'subtotal': subtotal,
    };
  }

  static String encode(List<Producto> productos) => 
    json.encode(productos.map((producto) => producto.toJson()).toList());

  static List<Producto> decode(String productos) =>
    (json.decode(productos) as List<dynamic>)
      .map<Producto>((item) => Producto.fromJson(item))
      .toList();
}