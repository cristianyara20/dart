// Importa el paquete de componentes visuales de Flutter basados en Material Design.
import 'package:flutter/material.dart';

// Punto de entrada principal de la aplicación.
void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false, // Oculta la cinta de DEBUG.
      home: CalculadoraScreen(), // Pantalla inicial de la app.
    ));

// Widget con estado (StatefulWidget) para refrescar la pantalla en cada clic.
class CalculadoraScreen extends StatefulWidget {
  const CalculadoraScreen({super.key});

  @override
  State<CalculadoraScreen> createState() => _CalculadoraScreenState();
}

// Clase de estado donde vive la lógica reactiva.
class _CalculadoraScreenState extends State<CalculadoraScreen> {
  final _c1 = TextEditingController(); // Controlador para el primer número.
  final _c2 = TextEditingController(); // Controlador para el segundo número.
 
  String _operacion = 'Suma'; // Guarda la operación activa.
  String _res = 'Resultado'; // Guarda el mensaje o número final a mostrar.

  // Lista con los nombres de las 4 operaciones.
  final List<String> _operaciones = ['Suma', 'Resta', 'Multiplicación', 'División'];

  @override
  void dispose() {
    _c1.dispose(); // Libera la memoria del controlador 1.
    _c2.dispose(); // Libera la memoria del controlador 2.
    super.dispose();
  }

  // Función que procesa los inputs y actualiza la variable _res.
  void _calcular() {
    double n1 = double.tryParse(_c1.text) ?? 0; // Lee número 1 o usa 0 si está vacío.
    double n2 = double.tryParse(_c2.text) ?? 0; // Lee número 2 o usa 0 si está vacío.
    double total = 0;

    switch (_operacion) {
      case 'Suma':
        total = n1 + n2;
        break;
      case 'Resta':
        total = n1 - n2;
        break;
      case 'Multiplicación':
        total = n1 * n2;
        break;
      case 'División':
        if (n2 == 0) {
          _res = 'Error: División por 0'; // Setea mensaje de error si el divisor es 0.
          return;
        }
        total = n1 / n2;
        break;
    }

    _res = 'Resultado: $total'; // Formatea el resultado calculado.
  }

  // Función para resetear campos y valores.
  void _limpiar() {
    setState(() {
      _c1.clear(); // Limpia la caja 1.
      _c2.clear(); // Limpia la caja 2.
      _res = 'Resultado'; // Restablece el visor de resultado.
    });
  }

  // Componente reutilizable para los inputs de texto numéricos.
  Widget _campoNumero(String label, TextEditingController controller) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(border: OutlineInputBorder()),
            // Opcional: calcula automáticamente si el usuario cambia el texto en la caja.
            onChanged: (_) => setState(() => _calcular()), 
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculadora de Operaciones')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _campoNumero('Número 1: ', _c1),
              const SizedBox(height: 15),
              _campoNumero('Número 2: ', _c2),
              const SizedBox(height: 20),

              const Text('Selecciona una operación:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),

              // --- SECCIÓN DE RADIO BUTTONS AUTO-CALCULABLES ---
              Column(
                children: _operaciones.map((op) {
                  return RadioListTile<String>(
                    title: Text(op),
                    value: op,
                    groupValue: _operacion,
                    dense: true,
                    // 🔥 SE ACTIVA AL DAR CLIC EN CUALQUIER RADIO BUTTON:
                    onChanged: (String? value) {
                      if (value != null) {
                        setState(() {
                          _operacion = value; // 1. Cambia la opción seleccionada.
                          _calcular();        // 2. Ejecuta el cálculo al instante.
                        });
                      }
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 15),

              // Botón único para limpiar.
              Center(
                child: OutlinedButton(
                  onPressed: _limpiar,
                  child: const Text('LIMPIAR'),
                ),
              ),

              const SizedBox(height: 25),

              // Muestra el resultado de forma dinámica e inmediata.
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 2)),
                child: Text(
                  _res,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}