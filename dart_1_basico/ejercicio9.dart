// Acceso condicional ?. y aserción !
// Enunciado. Sobre una variable String? correo, imprima su longitud de forma segura con ?. cuando es nula, y con ! cuando ya tiene valor.

void main(){
  String? correo;
  print(correo?.length ?? 0); // Imprime 0 si correo es nulo
  correo = 'juan@ejemplo.com';
  print(correo!.length); // Imprime la longitud de correo, asumiendo que no es nulo
}

/*
*Explicación. ?. propaga el nulo sin lanzar error (devuelve null). El operador ! es una promesa al compilador: «confía, aquí no es nulo»;
 si la promesa es falsa, el programa lanza un error en ejecución. Úselo solo cuando esté seguro; prefiera ?? y ?.
*/