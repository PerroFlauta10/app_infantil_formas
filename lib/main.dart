import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const AppInfantil());
}

class AppInfantil extends StatelessWidget {
  const AppInfantil({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aprende y Juega',
      theme: ThemeData(
        fontFamily: 'Comic Sans MS',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
      ),
      home: const MenuPrincipal(),
    );
  }
}

class MenuPrincipal extends StatefulWidget {
  const MenuPrincipal({super.key});

  @override
  State<MenuPrincipal> createState() => _MenuPrincipalState();
}

class _MenuPrincipalState extends State<MenuPrincipal> {
  int? juegoSeleccionado; // null: Menú principal, 1: Formas, 2: Mates

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fondo_menu.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2), // Filtro suave para que resalten los botones
          ),
          child: Center(
            child: SizedBox(
              width: 500,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (juegoSeleccionado == null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Text(
                        '🌟 APRENDE Y JUEGA 🌟',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE91E63),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF66BB6A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        elevation: 8,
                      ),
                      icon: const Icon(Icons.star, size: 36, color: Colors.yellow),
                      label: const Text('Juego de Formas', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      onPressed: () => setState(() => juegoSeleccionado = 1),
                    ),
                    const SizedBox(height: 25),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF42A5F5),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        elevation: 8,
                      ),
                      icon: const Icon(Icons.calculate, size: 36, color: Colors.amberAccent),
                      label: const Text('Juego de Mates', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      onPressed: () => setState(() => juegoSeleccionado = 2),
                    ),
                  ] else ...[
                    Expanded(
                      child: Stack(
                        children: [
                          Center(
                            child: juegoSeleccionado == 1
                                ? const JuegoFormasVisual()
                                : const JuegoMatesVisual(),
                          ),
                          Positioned(
                            top: 20,
                            left: 20,
                            child: FloatingActionButton.extended(
                              backgroundColor: Colors.redAccent,
                              icon: const Icon(Icons.arrow_back, color: Colors.white),
                              label: const Text('Salir', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                              onPressed: () => setState(() => juegoSeleccionado = null),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class JuegoFormasVisual extends StatefulWidget {
  const JuegoFormasVisual({super.key});

  @override
  State<JuegoFormasVisual> createState() => _JuegoFormasVisualState();
}

class _JuegoFormasVisualState extends State<JuegoFormasVisual> {
  String mensaje = "¡Encuentra la forma correcta!";
  int puntuacion = 0;
  int racha = 0;

  final List<Map<String, dynamic>> formasDisponibles = [
    {'nombre': 'Círculo', 'color': Colors.red, 'icon': Icons.circle},
    {'nombre': 'Cuadrado', 'color': Colors.blue, 'icon': Icons.square},
    {'nombre': 'Estrella', 'color': Colors.amber, 'icon': Icons.star},
    {'nombre': 'Corazón', 'color': Colors.pink, 'icon': Icons.favorite},
    {'nombre': 'Triángulo', 'color': Colors.green, 'icon': Icons.change_history},
    {'nombre': 'Hexágono', 'color': Colors.purple, 'icon': Icons.hexagon},
  ];

  late Map<String, dynamic> objetivo;
  late List<Map<String, dynamic>> opcionesActuales;

  @override
  void initState() {
    super.initState();
    _siguienteRonda();
  }

  void _siguienteRonda() {
    setState(() {
      formasDisponibles.shuffle();
      objetivo = formasDisponibles[0];
      
      int numOpciones = puntuacion >= 30 ? 4 : 3;
      opcionesActuales = formasDisponibles.take(numOpciones).toList();
      opcionesActuales.shuffle();

      if (!opcionesActuales.contains(objetivo)) {
        opcionesActuales[0] = objetivo;
        opcionesActuales.shuffle();
      }
      mensaje = "¡Encuentra la forma correcta!";
    });
  }

  void verificar(Map<String, dynamic> seleccionada) {
    setState(() {
      if (seleccionada['nombre'] == objetivo['nombre']) {
        puntuacion += 10;
        racha++;
        mensaje = "¡Excelente! 🎉 ¡Sigue así!";
        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) _siguienteRonda();
        });
      } else {
        racha = 0;
        mensaje = "¡Casi! Inténtalo otra vez. 💡";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      // --- AQUÍ CARGAMOS EL FONDO DE FORMAS ---
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        image: const DecorationImage(
          image: AssetImage('fondo_formas_menu.png'),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Container(
          // --- Capa semitransparente con opacidad 0.55 (igual a Mates) ---
          color: Colors.white.withOpacity(0.55), 
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('⭐ MODO FORMAS ⭐', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.green)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Puntos: $puntuacion 🌟', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                  const SizedBox(width: 20),
                  Text('Racha: $racha 🔥', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange)),
                ],
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.indigo.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.indigo, width: 2),
                ),
                child: Text(
                  'Busca: ${objetivo['nombre']}',
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.indigo),
                ),
              ),
              const SizedBox(height: 20),
              Text(mensaje, style: const TextStyle(fontSize: 20, color: Colors.orangeAccent, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              const SizedBox(height: 30),
              Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: opcionesActuales.map((f) {
                  return GestureDetector(
                    onTap: () => verificar(f),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: f['color'].withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: f['color'], width: 4),
                        boxShadow: [
                          BoxShadow(color: f['color'].withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Icon(f['icon'], size: 55, color: f['color']),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class JuegoMatesVisual extends StatefulWidget {
  const JuegoMatesVisual({super.key});

  @override
  State<JuegoMatesVisual> createState() => _JuegoMatesVisualState();
}

class _JuegoMatesVisualState extends State<JuegoMatesVisual> {
  final Random _random = Random();
  int num1 = 0;
  int num2 = 0;
  int respuestaCorrecta = 0;
  List<int> opciones = [];
  int puntuacion = 0;
  int racha = 0;
  String mensaje = "¡Resuelve la operación!";

  @override
  void initState() {
    super.initState();
    generarNuevaPregunta();
  }

  void generarNuevaPregunta() {
    setState(() {
      int rangoMax = puntuacion >= 40 ? 10 : (puntuacion >= 20 ? 8 : 5);
      num1 = _random.nextInt(rangoMax) + 1;
      num2 = _random.nextInt(rangoMax) + 1;
      respuestaCorrecta = num1 + num2;

      opciones = [respuestaCorrecta];
      while (opciones.length < (puntuacion >= 30 ? 4 : 3)) {
        int falsa = _random.nextInt(rangoMax * 2) + 1;
        if (!opciones.contains(falsa)) {
          opciones.add(falsa);
        }
      }
      opciones.shuffle();
      mensaje = "¡Resuelve la suma!";
    });
  }

  void verificar(int seleccionada) {
    setState(() {
      if (seleccionada == respuestaCorrecta) {
        puntuacion += 10;
        racha++;
        mensaje = "¡Excelente! 🚀 ¡Suma correcta!";
        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) generarNuevaPregunta();
        });
      } else {
        racha = 0;
        mensaje = "¡Casi! Prueba con otro número. 💪";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        image: const DecorationImage(
          image: AssetImage('assets/fondo_mates.png'),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Container(
          // Capa semitransparente con opacidad 0.55
          color: Colors.white.withOpacity(0.55), 
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🔢 MODO MATES 🔢', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.blue)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Puntos: $puntuacion 🌟', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                  const SizedBox(width: 20),
                  Text('Racha: $racha 🔥', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange)),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildNumeroCard(num1),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text('+', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.orange)),
                  ),
                  _buildNumeroCard(num2),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text('=', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.orange)),
                  ),
                  const Text('?', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 30),
              Text(mensaje, style: const TextStyle(fontSize: 20, color: Colors.teal, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              const SizedBox(height: 30),
              Wrap(
                spacing: 20,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: opciones.map((opcion) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 5,
                    ),
                    onPressed: () => verificar(opcion),
                    child: Text('$opcion', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumeroCard(int numero) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blue, width: 3),
      ),
      child: Text('$numero', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
    );
  }
}