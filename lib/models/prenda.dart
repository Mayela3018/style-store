class Prenda {
  int? id;
  String nombre;
  String categoria;
  String talla;
  double precio;
  int stock;
  String color;

  Prenda({
    this.id,
    required this.nombre,
    required this.categoria,
    required this.talla,
    required this.precio,
    required this.stock,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'categoria': categoria,
      'talla': talla,
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
      talla: map['talla'],
      precio: map['precio'],
      stock: map['stock'],
      color: map['color'],
    );
  }
}