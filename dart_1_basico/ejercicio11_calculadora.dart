// Importa el paquete de componentes visuales de Flutter basados en Material Design (botones, campos de texto, etc.).
import 'package:flutter/material.dart';

// Punto de entrada principal de la aplicación: invoca runApp para renderizar el widget MaterialApp.
void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false, // Oculta la marca/cinta de agua "DEBUG" en la esquina superior derecha.
      home: CalculadoraScreen(), // Define la pantalla inicial que se mostrará al abrir la aplicación.
    ));

// Widget con estado (StatefulWidget) que permite volver a dibujar la pantalla cuando cambia la selección o el resultado.
class CalculadoraScreen extends StatefulWidget {
  const CalculadoraScreen({super.key});

  @override
  State<CalculadoraScreen> createState() => _CalculadoraScreenState(); // Crea la instancia del estado asociado a este widget.
}

// Clase de estado que contiene las variables, controladores, métodos de cálculo y la vista (UI).
class _CalculadoraScreenState extends State<CalculadoraScreen> {
  final _c1 = TextEditingController(); // Controlador para leer, modificar y gestionar la primera caja de texto.
  final _c2 = TextEditingController(); // Controlador para leer, modificar y gestionar la segunda caja de texto.
 
  String _operacion = 'Suma'; // Guarda la operación seleccionada actualmente; inicia por defecto en 'Suma'.
  String _res = 'Resultado'; // Guarda el texto que se desplegará dentro del cuadro del resultado.

  // Lista con los nombres de las operaciones que se transformarán en los RadioButtons.
  final List<String> _operaciones = ['Suma', 'Resta', 'Multiplicación', 'División'];

  @override
  void dispose() {
    _c1.dispose(); // Libera la memoria utilizada por el primer controlador cuando la pantalla se destruye.
    _c2.dispose(); // Libera la memoria utilizada por el segundo controlador cuando la pantalla se destruye.
    super.dispose(); // Llama al método de limpieza de la clase padre.
  }

  // Función encargada de realizar la operación matemática seleccionada.
  void _calcular() {
    double n1 = double.tryParse(_c1.text) ?? 0; // Lee e intenta convertir el texto 1 a decimal; si es inválido o está vacío, usa 0.
    double n2 = double.tryParse(_c2.text) ?? 0; // Lee e intenta convertir el texto 2 a decimal; si es inválido o está vacío, usa 0.
    double total = 0; // Variable local temporal para almacenar la solución matemática.

    // Evalúa la opción elegida guardada en la variable _operacion para ejecutar el bloque correspondiente.
    switch (_operacion) {
      case 'Suma':
        total = n1 + n2; // Suma los dos valores ingresados.
        break;
      case 'Resta':
        total = n1 - n2; // Resta el segundo valor al primero.
        break;
      case 'Multiplicación':
        total = n1 * n2; // Multiplica ambos valores.
        break;
      case 'División':
        // Comprueba si el divisor es cero para evitar errores de división por cero.
        if (n2 == 0) {
          setState(() => _res = 'Error: División por 0'); // Muestra un mensaje de alerta en lugar de calcular.
          return; // Interrumpe la ejecución del método.
        }
        total = n1 / n2; // Divide el primer valor entre el segundo.
        break;
    }

    // Notifica al framework que el estado cambió para que redibuje la pantalla con el nuevo resultado.
    setState(() => _res = 'Resultado: $total');
  }

  // Función invocada por el botón LIMPIAR para resetear las entradas y la salida.
  void _limpiarOVerResultado() {
    setState(() {
      _c1.clear(); // Borra el texto ingresado en la primera caja.
      _c2.clear(); // Borra el texto ingresado en la segunda caja.
      _res = 'Resultado'; // Restablece el mensaje por defecto en el contenedor inferior.
    });
  }

  // Método auxiliar reutilizable que construye una fila compuesta por una etiqueta (Label) y una caja de entrada (TextField).
  Widget _campoNumero(String label, TextEditingController controller) {
    return Row( // Organiza sus componentes hijos de forma horizontal.
      children: [
        Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), // Muestra la etiqueta ("Número 1: " o "Número 2: ").
        const SizedBox(width: 10), // Crea una separación horizontal fija de 10 píxeles.
        Expanded(
          // Permite que el TextField se expanda ocupando todo el ancho libre restante en la fila.
          child: TextField(
            controller: controller, // Enlaza la caja de texto con el controlador asignado.
            keyboardType: const TextInputType.numberWithOptions(decimal: true), // Activa el teclado numérico con soporte para decimales.
            decoration: const InputDecoration(border: OutlineInputBorder()), // Aplica un borde rectangular completo alrededor de la caja.
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculadora de Operaciones')), // Renderiza la barra de navegación superior con el título.
      body: Padding(
        padding: const EdgeInsets.all(20.0), // Aplica un margen interno perimetral de 20 píxeles a todo el cuerpo.
        child: SingleChildScrollView( // Permite desplazarse verticalmente si el teclado o la pantalla limitan el espacio visual.
          child: Column( // Organiza los elementos verticales uno debajo del otro.
            crossAxisAlignment: CrossAxisAlignment.start, // Alinea los componentes hacia el borde izquierdo de la pantalla.
            children: [
              _campoNumero('Número 1: ', _c1), // Dibuja el primer campo numérico pasando el controlador _c1.
              const SizedBox(height: 15), // Separador vertical de 15 píxeles.
              _campoNumero('Número 2: ', _c2), // Dibuja el segundo campo numérico pasando el controlador _c2.
              const SizedBox(height: 20), // Separador vertical de 20 píxeles.

              // Título de la sección de selección.
              const Text('Selecciona una operación:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10), // Separador vertical de 10 píxeles.

              // --- SECCIÓN DE RADIO BUTTONS ---
              Column(
                // Mapea la lista de textos _operaciones convirtiendo cada elemento en un widget RadioListTile.
                children: _operaciones.map((op) {
                  return RadioListTile<String>(
                    title: Text(op), // Despliega el texto de la opción junto al botón circular (ej: "Suma").
                    value: op, // Asigna este valor específico al botón para que lo identifique.
                    groupValue: _operacion, // Compara el valor del botón con la variable activa; si coinciden, se marca.
                    dense: true, // Reduce la altura y márgenes del elemento para hacerlo más compacto.
                    onChanged: (String? value) {
                      if (value != null) {
                        setState(() => _operacion = value); // Actualiza la variable de estado con la nueva selección.
                      }
                    },
                  );
                }).toList(), // Convierte el resultado del mapeo en una lista válida de Widgets.
              ),

              const SizedBox(height: 15), // Separador vertical de 15 píxeles.

              // Contenedor horizontal que agrupa los botones de acción.
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // Centra los botones horizontalmente en la pantalla.
                children: [
                  // Botón principal elevado.
                  ElevatedButton(
                    onPressed: _calcular, // Asigna la función que evalúa la matemática.
                    child: const Text('CALCULAR'), // Texto dentro del botón.
                  ),
                  const SizedBox(width: 15), // Espaciado horizontal entre botones.
                  // Botón secundario con borde externo.
                  OutlinedButton(
                    onPressed: _limpiarOVerResultado, // Asigna la función que resetea las entradas.
                    child: const Text('LIMPIAR'), // Texto dentro del botón.
                  ),
                ],
              ),

              const SizedBox(height: 25), // Separador vertical de 25 píxeles.

              // Contenedor visual que emula la caja de texto final de salida.
              Container(
                width: double.infinity, // Hace que la caja se expanda a todo el ancho horizontal disponible.
                padding: const EdgeInsets.all(15), // Aplica relleno interno de 15 píxeles dentro de la caja.
                decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 2)), // Dibuja el borde gris con grosor de 2px.
                child: Text(
                  _res, // Renderiza el texto dinámico actualizado contenido en _res.
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), // Formatea el texto con estilo grande y negrita.
                  textAlign: TextAlign.center, // Centra el texto en el medio del cuadro.
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}