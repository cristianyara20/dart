void main(){
  // Interpolacion con expresiones
  // Enunciado: Calcule el promedio de tres notas directamente dentro de la cadena, usando l form ${expresion}
  double nota1 = 4.5, nota2 = 3.8, nota3 = 5.0;

  print ('El promedio de las notas es: ${(nota1 + nota2 + nota3) / 3}');


  /*
  Explicacion. Con $variable basta para valores simples; con ${expresion} puede evaluar cualquier operacion dentro de la cadena.
    Es la forma idiomatica en abrir
  */
  
}