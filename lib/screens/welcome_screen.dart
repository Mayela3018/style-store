import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Imagen de portada
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                child: Image.asset(
                  'assets/images/tienda.jpg',
                  width: double.infinity,
                  height: 260,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                width: double.infinity,
                height: 260,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      const Color(0xFFE91E8C).withOpacity(0.7),
                    ],
                  ),
                ),
              ),
              const Positioned(
                bottom: 20,
                left: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('StyleStore 👗',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold)),
                    Text('Tu tienda de ropa favorita',
                        style: TextStyle(color: Colors.white70, fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Descripción
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('¿Qué es StyleStore?',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE91E8C))),
                const SizedBox(height: 10),
                Text(
                  'StyleStore es tu gestor de inventario de ropa. '
                  'Agrega, edita y elimina prendas de manera fácil y rápida. '
                  'Mantén el control de tu stock, precios, tallas y colores en un solo lugar.',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      height: 1.6),
                ),
                const SizedBox(height: 24),

                // Cards de características
                const Text('¿Qué puedes hacer?',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE91E8C))),
                const SizedBox(height: 12),
                _buildFeatureCard(Icons.add_circle, 'Agregar prendas',
                    'Registra nuevas prendas con todos sus detalles', Colors.pink),
                _buildFeatureCard(Icons.edit, 'Editar información',
                    'Actualiza precio, stock y más con un toque', Colors.purple),
                _buildFeatureCard(Icons.delete, 'Eliminar prendas',
                    'Mantén tu inventario limpio y organizado', Colors.deepOrange),
                _buildFeatureCard(Icons.inventory_2, 'Control de stock',
                    'Visualiza cuántas unidades tienes disponibles', Colors.teal),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(IconData icon, String titulo, String descripcion, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 2),
                Text(descripcion,
                    style: TextStyle(
                        color: Colors.grey.shade600, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}