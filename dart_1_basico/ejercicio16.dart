/*
 Escalera if / else if / else
 Enunciado. Clasifique una nota según la escala de desempeño: Superior (desde 4.6), Alto (desde 4.0), Básico (desde 3.0) y Bajo (menor a 3.0).
*/

void main() {
  double nota = 4.2;

  if (nota >= 4.6) {
    print('Desempeño: Superior');
  } else if (nota >= 4.0) {
    print('Desempeño: Alto');
  } else if (nota >= 3.0) {
    print('Desempeño: Básico');
  } else {
    print('Desempeño: Bajo');
  }
}