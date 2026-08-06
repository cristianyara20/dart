void main(){
  int numero1 = int.parse('42');
  double nota = double.parse('4.5');
  double pi = 3.14159;

  print(numero1 + 8);
  print(nota + 0.5);
  print('El número π con dos decimales es: ${pi.toStringAsFixed(4)}');
}

/*
 * Explicación. int.parse y double.parse convierten texto a número (lanzan FormatException si el texto no es válido: pruébelo).
 toStringAsFixed(n) devuelve una cadena con n decimales, ideal para mostrar notas y precios.
 */