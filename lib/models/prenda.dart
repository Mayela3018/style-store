class Prenda {
  int? id;
  String nombre;
  String categoria;
  String tallas; // "M,L,XL" separado por comas
  double precio;
  int stock;
  String color;

  Prenda({
    this.id,
    required this.nombre,
    required this.categoria,
    required this.tallas,
    required this.precio,
    required this.stock,
    required this.color,
  });

  // Helper para obtener lista de tallas
  List<String> get tallasList =>
      tallas.split(',').map((t) => t.trim()).where((t) => t.isNotEmpty).toList();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'categoria': categoria,
      'talla': tallas,
      'precio': precio,
      'stock': stock,
      'color': color,
    };
  }

  factory Prenda.fromMap(Map<String, dynamic> map) {
    return Prenda(
      id: map['id'],
      nombre: map['nombre'],
      categoria: map['categoria'],
      tallas: map['talla'],
      precio: map['precio'],
      stock: map['stock'],
      color: map['color'],
    );
  }
}