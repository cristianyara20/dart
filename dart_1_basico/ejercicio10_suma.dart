// Importa el paquete de UI de Material Design que contiene los widgets (botones, cajas de texto, etc.).
import 'package:flutter/material.dart';

// Punto de entrada principal: ejecuta la aplicación iniciando el widget raíz MaterialApp.
void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false, // Oculta la etiqueta o cinta roja de "DEBUG" en la esquina superior derecha.
      home: PantallaSuma(), // Establece PantallaSuma como la vista o pantalla principal que se mostrará al abrir la app.
    ));

// Widget con estado (StatefulWidget) utilizado porque la pantalla requiere cambiar su contenido dinámicamente al sumar.
class PantallaSuma extends StatefulWidget {
  const PantallaSuma({super.key});

  @override
  State<PantallaSuma> createState() => _PantallaSumaState(); // Crea y asocia la clase de estado (_PantallaSumaState) a este widget.
}

// Clase de Estado que almacena las variables, la lógica matemática y la estructura de la interfaz de usuario.
class _PantallaSumaState extends State<PantallaSuma> {
  // Controlador que se conecta al primer TextField para capturar y leer el texto ingresado en tiempo real.
  final _c1 = TextEditingController(); 

  // Controlador que se conecta al segundo TextField para capturar y leer el texto ingresado en tiempo real.
  final _c2 = TextEditingController(); 

  // Variable de tipo String donde se guarda el texto que se mostrará en la caja final de resultado.
  String _res = 'Resultado'; 

  // Función encargada de procesar la lógica matemática de la suma.
  void _sumar() {
    // Convierte el texto capturado del primer campo a número (double). Si está vacío o es inválido, asigna 0 por seguridad.
    double n1 = double.tryParse(_c1.text) ?? 0; 

    // Convierte el texto capturado del segundo campo a número (double). Si está vacío o es inválido, asigna 0 por seguridad.
    double n2 = double.tryParse(_c2.text) ?? 0; 

    // setState le notifica a Flutter que el estado cambió; esto fuerza a la pantalla a redibujarse para mostrar el nuevo resultado.
    setState(() => _res = 'Resultado: ${n1 + n2}'); 
  }

  // Método auxiliar reutilizable que devuelve una fila (Row) con una etiqueta y un campo de texto para evitar duplicar código.
  Widget _campoNumero(String label, TextEditingController controller) {
    return Row( // Dispone sus widgets hijos en una línea horizontal.
      children: [
        // Etiqueta de texto fija con estilo en negrita y tamaño 18.
        Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), 

        const SizedBox(width: 10), // Separador horizontal transparente de 10 píxeles.

        // Expanded obliga al TextField a ocupar todo el espacio horizontal restante disponible dentro de la fila.
        Expanded(
          child: TextField(
            controller: controller, // Asigna el controlador que gestiona la entrada de texto de esta caja.
            keyboardType: TextInputType.number, // Configura el teclado del dispositivo para mostrar sólo números.
            decoration: const InputDecoration(border: OutlineInputBorder()), // Aplica un borde rectangular alrededor de la caja.
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold provee el lienzo y la estructura visual base de Material Design (AppBar y cuerpo).
    return Scaffold(
      appBar: AppBar(title: const Text('Ejercicio Sumar')), // Barra superior de navegación que muestra el título de la app.
      
      // Body es el área de contenido principal con un margen (padding) perimetral de 20 píxeles.
      body: Padding(
        padding: const EdgeInsets.all(20.0), 

        // Column organiza todos sus widgets hijos de manera vertical (uno debajo del otro).
        child: Column(
          children: [
            _campoNumero('Número 1: ', _c1), // Dibuja la primera fila (Label + Caja de entrada para el primer número).
            
            const SizedBox(height: 15), // Separador vertical transparente de 15 píxeles.
            
            _campoNumero('Número 2: ', _c2), // Dibuja la segunda fila (Label + Caja de entrada para el segundo número).
            
            const SizedBox(height: 20), // Separador vertical transparente de 20 píxeles.
            
            // Botón elevado que ejecuta la función _sumar cuando el usuario hace clic sobre él.
            ElevatedButton(
              onPressed: _sumar, 
              child: const Text('SUMAR'), // Texto desplegado dentro del botón.
            ), 
            
            const SizedBox(height: 20), // Separador vertical transparente de 20 píxeles.
            
            // Contenedor rectangular que actúa como el cuadro de visualización del resultado.
            Container(
              width: double.infinity, // Define que el contenedor abarque todo el ancho disponible.
              padding: const EdgeInsets.all(15), // Relleno interno de 15 píxeles en todos los lados.
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 2), // Define un borde continuo gris de 2 píxeles de grosor.
              ),
              
              // Widget de texto centrado que renderiza el valor actual asignado en la variable _res.
              child: Text(
                _res, 
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), 
                textAlign: TextAlign.center,
              ), 
            ),
          ],
        ),
      ),
    );
  }
}