/* Inferencia de tipos con var */

void main() {
  var nombre = 'Juan';
  var edad = 25;
  var esEstudiante = true;
  var promedio = 8.5;

  //edad = 'abc';

/*
  print('Nombre: $nombre');
  print('Edad: $edad');
  print('Es estudiante: $esEstudiante');
  print('Promedio: $promedio');
*/

  print('Nombre: $nombre · Edad: $edad · Promedio: $promedio');

}

/*
Explicación. Con var, el compilador infiere el tipo a partir del valor asignado (String, int y double respectivamente) y
ese tipo queda fijo: si luego intenta asignar ficha = 'abc', el compilador lo rechaza. Inferencia no es ausencia de tipo.
*/