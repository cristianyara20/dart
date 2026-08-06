// Variables anulables y el operador ??
void main(){
  String? nombre; // Variable anulable
  //print(nombre ?? 'Sin Nombre registrado');
  nombre = 'Juan';
  print(nombre ?? 'Sin Nombre registrado');

}