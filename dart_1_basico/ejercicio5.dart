void main(){

  const double notaMaxima = 5.0; // Valor fijo desde el inicio del programa (T. Compilación)
  final int codigoSesion = DateTime.now().millisecond;   // Valor fijo desde el inicio del programa (T. Ejecución)
  print ('La nota máxima institucional es : $notaMaxima');
  print ('El código de sesión se generó en tiempo de ejecución: $codigoSesion');
  // notaMaxima = 6.0;  -> error: no se puede reasignar
  print(codigoSesion >= 0); // solo comprobamos que existe

}