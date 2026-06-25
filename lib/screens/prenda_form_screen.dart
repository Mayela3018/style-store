import 'package:flutter/material.dart';
import '../models/prenda.dart';
import '../database/database_helper.dart';

class PrendaFormScreen extends StatefulWidget {
  final Prenda? prenda;

  const PrendaFormScreen({super.key, this.prenda});

  @override
  State<PrendaFormScreen> createState() => _PrendaFormScreenState();
}

class _PrendaFormScreenState extends State<PrendaFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nombreCtrl;
  late TextEditingController _precioCtrl;
  late TextEditingController _stockCtrl;

  String _categoriaSeleccionada = 'Polos';
  String _colorSeleccionado = 'Negro';
  List<String> _tallasSeleccionadas = [];

  final List<String> _categorias = ['Polos', 'Pantalones', 'Vestidos', 'Blusas', 'Shorts', 'Chaquetas'];
  final List<String> _tallasDisponibles = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];
  final List<String> _colores = ['Negro', 'Blanco', 'Rojo', 'Azul', 'Verde', 'Rosa', 'Amarillo', 'Morado'];

  @override
  void initState() {
    super.initState();
    _nombreCtrl = TextEditingController(text: widget.prenda?.nombre ?? '');
    _precioCtrl = TextEditingController(text: widget.prenda?.precio.toString() ?? '');
    _stockCtrl = TextEditingController(text: widget.prenda?.stock.toString() ?? '');

    if (widget.prenda != null) {
      _categoriaSeleccionada = widget.prenda!.categoria;
      _colorSeleccionado = widget.prenda!.color;
      _tallasSeleccionadas = widget.prenda!.tallasList;
    }
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _precioCtrl.dispose();
    _stockCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    if (_tallasSeleccionadas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecciona al menos una talla'),
          backgroundColor: Color(0xFFE91E8C),
        ),
      );
      return;
    }

    final prenda = Prenda(
      id: widget.prenda?.id,
      nombre: _nombreCtrl.text.trim(),
      categoria: _categoriaSeleccionada,
      tallas: _tallasSeleccionadas.join(','),
      precio: double.parse(_precioCtrl.text),
      stock: int.parse(_stockCtrl.text),
      color: _colorSeleccionado,
    );

    if (widget.prenda == null) {
      await DatabaseHelper.instance.insertPrenda(prenda);
    } else {
      await DatabaseHelper.instance.updatePrenda(prenda);
    }

    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final esEditar = widget.prenda != null;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      appBar: AppBar(
        title: Text(esEditar ? 'Editar Prenda' : 'Nueva Prenda'),
        backgroundColor: const Color(0xFFE91E8C),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(_nombreCtrl, 'Nombre de la prenda', Icons.checkroom),
              const SizedBox(height: 16),
              _buildDropdown('Categoría', _categorias, _categoriaSeleccionada, Icons.category, (val) {
                setState(() => _categoriaSeleccionada = val!);
              }),
              const SizedBox(height: 16),

              // Selector de tallas múltiples
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.straighten, color: const Color(0xFFE91E8C), size: 20),
                        const SizedBox(width: 8),
                        const Text('Tallas disponibles',
                            style: TextStyle(fontSize: 14, color: Colors.black87)),
                        const SizedBox(width: 8),
                        if (_tallasSeleccionadas.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE91E8C),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text('${_tallasSeleccionadas.length} seleccionadas',
                                style: const TextStyle(color: Colors.white, fontSize: 11)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _tallasDisponibles.map((talla) {
                        final seleccionada = _tallasSeleccionadas.contains(talla);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (seleccionada) {
                                _tallasSeleccionadas.remove(talla);
                              } else {
                                _tallasSeleccionadas.add(talla);
                              }
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                            decoration: BoxDecoration(
                              color: seleccionada
                                  ? const Color(0xFFE91E8C)
                                  : Colors.pink.shade50,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: seleccionada
                                    ? const Color(0xFFE91E8C)
                                    : Colors.pink.shade200,
                              ),
                            ),
                            child: Text(
                              talla,
                              style: TextStyle(
                                color: seleccionada ? Colors.white : Colors.pink.shade400,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              _buildDropdown('Color', _colores, _colorSeleccionado, Icons.color_lens, (val) {
                setState(() => _colorSeleccionado = val!);
              }),
              const SizedBox(height: 16),
              _buildTextField(_precioCtrl, 'Precio (S/.)', Icons.attach_money,
                  keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              _buildTextField(_stockCtrl, 'Stock', Icons.inventory,
                  keyboardType: TextInputType.number),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _guardar,
                  icon: Icon(esEditar ? Icons.save : Icons.add),
                  label: Text(esEditar ? 'Guardar cambios' : 'Agregar prenda',
                      style: const TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE91E8C),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String label, IconData icon,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFFE91E8C)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE91E8C), width: 2),
        ),
      ),
      validator: (val) => val == null || val.isEmpty ? 'Este campo es requerido' : null,
    );
  }

  Widget _buildDropdown(String label, List<String> items, String value, IconData icon,
      void Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFFE91E8C)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE91E8C), width: 2),
        ),
      ),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
  }
}