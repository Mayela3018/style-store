import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/prenda.dart';
import 'prenda_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Prenda> _prendas = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarPrendas();
  }

  Future<void> _cargarPrendas() async {
    setState(() => _cargando = true);
    final prendas = await DatabaseHelper.instance.getAllPrendas();
    setState(() {
      _prendas = prendas;
      _cargando = false;
    });
  }

  Future<void> _eliminar(int id) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('¿Eliminar prenda?'),
        content: const Text('Esta acción no se puede deshacer.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmar == true) {
      await DatabaseHelper.instance.deletePrenda(id);
      _cargarPrendas();
    }
  }

  Color _getColorFromString(String color) {
    switch (color.toLowerCase()) {
      case 'negro': return Colors.black87;
      case 'blanco': return Colors.grey.shade300;
      case 'rojo': return Colors.red;
      case 'azul': return Colors.blue;
      case 'verde': return Colors.green;
      case 'rosa': return Colors.pink;
      case 'amarillo': return Colors.amber;
      case 'morado': return Colors.purple;
      default: return Colors.grey;
    }
  }

  IconData _getCategoriaIcon(String categoria) {
    switch (categoria) {
      case 'Polos': return Icons.checkroom;
      case 'Pantalones': return Icons.man;
      case 'Vestidos': return Icons.woman;
      case 'Blusas': return Icons.dry_cleaning;
      case 'Shorts': return Icons.beach_access;
      case 'Chaquetas': return Icons.ac_unit;
      default: return Icons.checkroom;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      // appBar eliminada para usar la del MainNavigation
      body: _cargando
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFE91E8C)))
          : _prendas.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.checkroom, size: 80, color: Colors.pink.shade200),
                      const SizedBox(height: 16),
                      Text('No hay prendas aún',
                          style: TextStyle(fontSize: 18, color: Colors.pink.shade300)),
                      const SizedBox(height: 8),
                      Text('Toca el botón + para agregar',
                          style: TextStyle(color: Colors.grey.shade500)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _prendas.length,
                  itemBuilder: (context, index) {
                    final prenda = _prendas[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFFE91E8C).withOpacity(0.1),
                          child: Icon(_getCategoriaIcon(prenda.categoria),
                              color: const Color(0xFFE91E8C)),
                        ),
                        title: Text(prenda.nombre,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text('${prenda.categoria} • Talla ${prenda.talla}',
                                style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  width: 14,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: _getColorFromString(prenda.color),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.grey.shade300),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(prenda.color,
                                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                                const SizedBox(width: 12),
                                Icon(Icons.inventory_2, size: 13, color: Colors.grey.shade500),
                                const SizedBox(width: 4),
                                Text('Stock: ${prenda.stock}',
                                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                              ],
                            ),
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('S/. ${prenda.precio.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    color: Color(0xFFE91E8C),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14)),
                          ],
                        ),
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => PrendaFormScreen(prenda: prenda)),
                          );
                          if (result == true) _cargarPrendas();
                        },
                        onLongPress: () => _eliminar(prenda.id!),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PrendaFormScreen()),
          );
          if (result == true) _cargarPrendas();
        },
        backgroundColor: const Color(0xFFE91E8C),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Agregar'),
      ),
    );
  }
}