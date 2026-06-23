import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/prenda.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Prenda> _prendas = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    setState(() => _cargando = true);
    final prendas = await DatabaseHelper.instance.getAllPrendas();
    setState(() {
      _prendas = prendas;
      _cargando = false;
    });
  }

  double get _valorTotal =>
      _prendas.fold(0, (sum, p) => sum + (p.precio * p.stock));

  int get _totalStock => _prendas.fold(0, (sum, p) => sum + p.stock);

  List<Prenda> get _pocosStock =>
      _prendas.where((p) => p.stock <= 3).toList();

  Map<String, int> get _porCategoria {
    final Map<String, int> mapa = {};
    for (final p in _prendas) {
      mapa[p.categoria] = (mapa[p.categoria] ?? 0) + 1;
    }
    return mapa;
  }

  String get _categoriaTop {
    if (_porCategoria.isEmpty) return '-';
    return _porCategoria.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  @override
  Widget build(BuildContext context) {
    return _cargando
        ? const Center(child: CircularProgressIndicator(color: Color(0xFFE91E8C)))
        : RefreshIndicator(
            color: const Color(0xFFE91E8C),
            onRefresh: _cargarDatos,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE91E8C), Color(0xFFAD1457)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('📊 Dashboard',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('Resumen de tu inventario',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 13)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Cards de estadísticas
                  const Text('Resumen general',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE91E8C))),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          '👗',
                          'Total prendas',
                          '${_prendas.length}',
                          const Color(0xFFE91E8C),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          '📦',
                          'Total stock',
                          '$_totalStock',
                          const Color(0xFF9C27B0),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          '💰',
                          'Valor inventario',
                          'S/. ${_valorTotal.toStringAsFixed(2)}',
                          const Color(0xFF00897B),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          '🏆',
                          'Top categoría',
                          _categoriaTop,
                          const Color(0xFFFF6F00),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Gráfico por categoría
                  const Text('Prendas por categoría',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE91E8C))),
                  const SizedBox(height: 12),
                  _porCategoria.isEmpty
                      ? _buildEmpty('No hay datos aún')
                      : Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.pink.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            children: _porCategoria.entries.map((entry) {
                              final maxVal = _porCategoria.values
                                  .reduce((a, b) => a > b ? a : b);
                              final porcentaje = entry.value / maxVal;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(entry.key,
                                            style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500)),
                                        Text('${entry.value} prendas',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey.shade600)),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: LinearProgressIndicator(
                                        value: porcentaje,
                                        minHeight: 10,
                                        backgroundColor:
                                            Colors.pink.shade50,
                                        valueColor:
                                            const AlwaysStoppedAnimation<Color>(
                                                Color(0xFFE91E8C)),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                  const SizedBox(height: 24),

                  // Prendas con poco stock
                  Row(
                    children: [
                      const Text('⚠️ Poco stock',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFE91E8C))),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text('${_pocosStock.length}',
                            style: TextStyle(
                                color: Colors.orange.shade800,
                                fontWeight: FontWeight.bold,
                                fontSize: 12)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _pocosStock.isEmpty
                      ? _buildEmpty('¡Todo el stock está bien! 🎉')
                      : Column(
                          children: _pocosStock.map((p) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                    color: Colors.orange.shade200),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.orange.withOpacity(0.1),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor:
                                        Colors.orange.shade50,
                                    child: Icon(Icons.warning_amber,
                                        color: Colors.orange.shade700,
                                        size: 20),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(p.nombre,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14)),
                                        Text(
                                            '${p.categoria} • Talla ${p.talla}',
                                            style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 12)),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: p.stock == 0
                                          ? Colors.red.shade100
                                          : Colors.orange.shade100,
                                      borderRadius:
                                          BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      p.stock == 0
                                          ? 'Agotado'
                                          : 'Stock: ${p.stock}',
                                      style: TextStyle(
                                          color: p.stock == 0
                                              ? Colors.red.shade700
                                              : Colors.orange.shade700,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
  }

  Widget _buildStatCard(
      String emoji, String titulo, String valor, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 8),
          Text(valor,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color)),
          const SizedBox(height: 4),
          Text(titulo,
              style:
                  TextStyle(fontSize: 11, color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  Widget _buildEmpty(String mensaje) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(mensaje,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey.shade500)),
    );
  }
}