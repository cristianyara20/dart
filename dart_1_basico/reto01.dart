void main() {
  // 1. Declaración de variables
  String nombre = "Ana Gómez";
  int ficha = 2671234;
  double promedio = 4.8;
  bool activo = true;
 
  // Variable que permite valores nulos
  String? telefonoAcudiente = null;

  // 2. Impresión de la ficha en 4 líneas
  print("1. Aprendiz: $nombre (Ficha: $ficha)");
  print("2. Estado: ${activo ? 'Activo' : 'Inactivo'}");
  print("3. Promedio general: $promedio");
  print("4. Teléfono acudiente: ${telefonoAcudiente ?? 'No registrado'}");
}