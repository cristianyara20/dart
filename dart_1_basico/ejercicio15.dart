/*
. Operadores relacionales y lógicos
Enunciado. Un aprendiz aprueba si su nota es mayor o igual a 3.0 Y su asistencia es al menos del 80 %.
Evalúe también si tiene mención especial (nota mayor o igual a 4.5 O asistencia perfecta).

*/
void main() {
  double nota = 3.8;
  double asistencia = 85;

  bool aprueba = (nota >= 3.0) && (asistencia >= 80.0);
  bool mencionEspecial = (nota >= 4.5) || (asistencia == 100.0);

  print('Aprueba: $aprueba');
  print('Mención especial: $mencionEspecial');
}

/*
 Explicación. && exige que ambas condiciones sean verdaderas;
 || se conforma con una. Dart evalúa en cortocircuito: en &&, si la primera es falsa, ni siquiera evalúa la segunda.
*/