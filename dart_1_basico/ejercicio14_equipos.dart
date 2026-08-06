// Importa el paquete fundamental de Flutter que contiene todos los widgets de Material Design
import 'package:flutter/material.dart';

// Enum (enumeración) que define las dos opciones posibles para dividir los equipos:
// - numberOfTeams: Dividir creando 'N' cantidad de equipos.
// - participantsPerTeam: Dividir creando equipos de 'N' miembros cada uno.
enum DivisionMode { numberOfTeams, participantsPerTeam }

// Punto de entrada principal de la aplicación en Dart
void main() {
  // Inicializa la ejecución de la aplicación cargando el widget raíz 'TeamGeneratorApp'
  runApp(const TeamGeneratorApp());
}

// Widget de tipo StatelessWidget (sin estado dinámico) que representa la configuración global de la App
class TeamGeneratorApp extends StatelessWidget {
  const TeamGeneratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp configura temas, título global y estructura de navegación básica
    return MaterialApp(
      title: 'Generador de Equipos', // Título que se muestra en la pestaña del navegador o tarea
      debugShowCheckedModeBanner: false, // Oculta la etiqueta "DEBUG" en la esquina superior derecha
      theme: ThemeData(
        // Define el esquema de colores a partir de un color base (Magenta/Rosado)
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFC2185B),
          primary: const Color(0xFFC2185B),
        ),
        scaffoldBackgroundColor: const Color(0xFFF3F4F6), // Color de fondo gris claro para toda la app
        useMaterial3: true, // Habilita la especificación visual Material Design 3
      ),
      home: const TeamGeneratorScreen(), // Establece la pantalla inicial de la aplicación
    );
  }
}

// Pantalla principal (Contenedor que estructura el Scaffold, Appbar y el scroll general)
class TeamGeneratorScreen extends StatelessWidget {
  const TeamGeneratorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra superior de la aplicación
      appBar: AppBar(
        title: const Text(
          'Generador de Equipos y Grupos', 
          style: TextStyle(color: Colors.white)
        ),
        backgroundColor: const Color(0xFFC2185B), // Color de fondo magenta de la barra
        centerTitle: true, // Centra el texto del título
      ),
      // Permite hacer scroll si el contenido sobrepasa la pantalla verticalmente
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0), // Margen interno alrededor de toda la pantalla
        child: Center(
          // ConstrainedBox limita el ancho máximo del contenido para que se vea bien en pantallas anchas (PC)
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900), // Ancho máximo de 900 píxeles
            child: const TeamGeneratorForm(), // Carga el formulario con la lógica interactiva
          ),
        ),
      ),
    );
  }
}

// Widget StatefulWidget que contendrá el estado (datos que cambian dinámicamente)
class TeamGeneratorForm extends StatefulWidget {
  const TeamGeneratorForm({super.key});

  @override
  State<TeamGeneratorForm> createState() => _TeamGeneratorFormState();
}

// Clase de Estado que controla la lógica de negocio y la interfaz reactiva
class _TeamGeneratorFormState extends State<TeamGeneratorForm> {
  // Controladores para leer y modificar el texto ingresado en las cajas de texto
  final TextEditingController _participantsController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  // Variables de Estado (State)
  DivisionMode _divisionMode = DivisionMode.numberOfTeams; // Modo de división seleccionado por defecto
  int _selectedQuantity = 2; // Cantidad seleccionada en el menú desplegable (por defecto: 2)
  int _participantCount = 0; // Contador en tiempo real del número de participantes

  // Mapa donde la clave es el nombre del equipo ("Equipo 1") y el valor es la lista de miembros
  Map<String, List<String>> _generatedTeams = {};

  @override
  void initState() {
    super.initState();
    // Escucha cada cambio en el input de participantes para actualizar el contador automáticamente
    _participantsController.addListener(_updateParticipantCount);
  }

  @override
  void dispose() {
    // Se liberan los controladores y listeners de la memoria cuando el widget se destruye
    _participantsController.removeListener(_updateParticipantCount);
    _participantsController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  // Método que calcula cuántos participantes válidos hay ingresados
  void _updateParticipantCount() {
    // Separa el texto por saltos de línea, elimina espacios en blanco extras y filtra líneas vacías
    final lines = _participantsController.text
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    
    // setState notifica a Flutter que actualice la UI con la nueva cantidad
    setState(() {
      _participantCount = lines.length;
    });
  }

  // Método para reiniciar todos los campos del formulario
  void _clearForm() {
    setState(() {
      _participantsController.clear(); // Limpia el texto de participantes
      _titleController.clear(); // Limpia el título
      _selectedQuantity = 2; // Restablece a 2
      _divisionMode = DivisionMode.numberOfTeams; // Restablece modo por defecto
      _generatedTeams.clear(); // Borra los equipos generados previamente
    });
  }

  // ALGORITMO PRINCIPAL DE INGENIERÍA INVERSA: Generación y división de equipos
  void _generateTeams() {
    // 1. Obtiene y limpia la lista de nombres ingresados
    final rawList = _participantsController.text
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    // Validar que la lista no esté vacía
    if (rawList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa al menos un participante.')),
      );
      return;
    }

    // 2. Aleatorización: Mezcla los nombres de forma completamente azarosa
    rawList.shuffle();

    Map<String, List<String>> teams = {};

    // OPCIÓN A: Dividir por Cantidad Fixa de Equipos
    if (_divisionMode == DivisionMode.numberOfTeams) {
      int numTeams = _selectedQuantity;
      
      // Inicializar cada equipo vacío en el mapa
      for (int i = 0; i < numTeams; i++) {
        teams['Equipo ${i + 1}'] = [];
      }
      
      // Repartir los participantes uno a uno entre los equipos usando el operador Módulo (%)
      for (int i = 0; i < rawList.length; i++) {
        int teamIndex = i % numTeams; // Rotación cíclica entre los equipos
        teams['Equipo ${teamIndex + 1}']!.add(rawList[i]);
      }
    } 
    // OPCIÓN B: Dividir por Cantidad de Participantes por Equipo
    else {
      int perTeam = _selectedQuantity;
      int teamIndex = 1;

      // Cortar la lista en bloques (sublistas) del tamaño solicitado
      for (int i = 0; i < rawList.length; i += perTeam) {
        int end = (i + perTeam < rawList.length) ? i + perTeam : rawList.length;
        teams['Equipo $teamIndex'] = rawList.sublist(i, end);
        teamIndex++;
      }
    }

    // Actualiza el estado con la nueva estructura de equipos generada
    setState(() {
      _generatedTeams = teams;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Título de la sección
        const Text(
          'Generador de Equipos y Grupos Aleatorios',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        // Subtítulo explicativo
        const Text(
          'Crea equipos al azar a partir de una lista de nombres de forma automática.',
          style: TextStyle(color: Colors.black54, fontSize: 14),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),

        // TARJETA CONTENEDORA DE FORMULARIO
        Card(
          elevation: 1, // Sombra sutil
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: LayoutBuilder(
              // LayoutBuilder detecta el ancho disponible para hacer la interfaz responsive
              builder: (context, constraints) {
                // Si el ancho es menor a 600px se considera pantalla móvil
                bool isMobile = constraints.maxWidth < 600;

                return Column(
                  children: [
                    // Flex permite cambiar dinámicamente de horizontal (Fila) a vertical (Columna)
                    Flex(
                      direction: isMobile ? Axis.vertical : Axis.horizontal,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        
                        // --- COLUMNA 1: Entrada de Participantes ---
                        Expanded(
                          flex: isMobile ? 0 : 1, // Si es móvil no se expande, toma su propio alto
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '1. Ingresa los participantes',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              const SizedBox(height: 8),
                              
                              // Stack superpone el contador de participantes dentro del campo de texto
                              Stack(
                                children: [
                                  TextField(
                                    controller: _participantsController,
                                    maxLines: 8, // Campo multilínea grande
                                    decoration: const InputDecoration(
                                      hintText: 'Cada participante debe estar en una nueva línea',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  // Badge / Insignia flotante con el número de participantes cargados
                                  Positioned(
                                    right: 12,
                                    bottom: 12,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.pink.shade50,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        '$_participantCount', // Muestra el entero dinámico
                                        style: const TextStyle(
                                          color: Color(0xFFC2185B),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Separador responsive (espacio horizontal en PC, vertical en Mobile)
                        SizedBox(width: isMobile ? 0 : 20, height: isMobile ? 20 : 0),

                        // --- COLUMNA 2: Opciones de configuración ---
                        Expanded(
                          flex: isMobile ? 0 : 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '2. Cómo dividir:',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              
                              // Botón de opción (Radio Button) 1: Cantidad de equipos
                              RadioListTile<DivisionMode>(
                                title: const Text('Cantidad de equipos'),
                                value: DivisionMode.numberOfTeams,
                                groupValue: _divisionMode, // Compara con la variable de estado actual
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                onChanged: (val) => setState(() => _divisionMode = val!),
                              ),
                              
                              // Botón de opción (Radio Button) 2: Participantes por equipo
                              RadioListTile<DivisionMode>(
                                title: const Text('Participantes por equipo'),
                                value: DivisionMode.participantsPerTeam,
                                groupValue: _divisionMode,
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                onChanged: (val) => setState(() => _divisionMode = val!),
                              ),
                              
                              const SizedBox(height: 4),

                              // Menú Desplegable (Dropdown) con números del 1 al 20
                              DropdownButtonFormField<int>(
                                value: _selectedQuantity,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                                items: List.generate(20, (index) => index + 1)
                                    .map((e) => DropdownMenuItem(
                                          value: e,
                                          // El texto cambia según la opción seleccionada en el RadioButton
                                          child: Text('$e ${_divisionMode == DivisionMode.numberOfTeams ? "equipos" : "por equipo"}'),
                                        ))
                                    .toList(),
                                onChanged: (val) => setState(() => _selectedQuantity = val!),
                              ),

                              const SizedBox(height: 16),

                              // Campo de texto opcional para darle un título al torneo o sorteo
                              const Text(
                                '3. Título',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _titleController,
                                decoration: const InputDecoration(
                                  hintText: 'Ej. Torneo de Fútbol 2026',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // --- BOTONES DE ACCIÓN ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Botón Limpiar
                        TextButton(
                          onPressed: _clearForm,
                          child: const Text('Limpiar', style: TextStyle(color: Color(0xFFC2185B))),
                        ),
                        const SizedBox(width: 12),
                        
                        // Botón Ejecutar / Generar Equipos
                        ElevatedButton(
                          onPressed: _generateTeams,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFC2185B),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Generar equipos'),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),

        // --- VISTA DE RESULTADOS (SOLO SE RENDERIZA SI HAY EQUIPOS GENERADOS) ---
        if (_generatedTeams.isNotEmpty) ...[
          const SizedBox(height: 28),
          
          // Renderiza el Título personalizado si fue ingresado por el usuario
          if (_titleController.text.isNotEmpty)
            Text(
              _titleController.text,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 16),

          // Wrap organiza las tarjetas de cada equipo en cuadrícula flexible
          Wrap(
            spacing: 16, // Espacio horizontal entre tarjetas
            runSpacing: 16, // Espacio vertical cuando salta de línea
            alignment: WrapAlignment.center,
            // Mapea la estructura Map<String, List<String>> a Widgets de tipo Card
            children: _generatedTeams.entries.map((entry) {
              return SizedBox(
                width: 260, // Ancho fijo por tarjeta de equipo
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nombre del equipo (Clave del mapa, ej: "Equipo 1")
                        Text(
                          entry.key,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFC2185B),
                            fontSize: 16,
                          ),
                        ),
                        const Divider(),
                        
                        // Itera e imprime cada miembro asignado a este equipo
                        ...entry.value.map((member) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2.0),
                              child: Text('• $member'),
                            )),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}