//Por Djheyson Oliveira

//Código Adaptado de https://github.com/una1veritas/Processing-sketches/blob/master/libraries/udp/examples/udp/udp.pde

/*
Execute este cliente udp, o servidor não precisa estar,
mas para enviar e receber dados execute o servidor,
após a execução dos dois digite algum caractere que
ele será enviado para o servidor.

obs: caracteres enviados do servidor vão para os dois
clientes udp
*/

import hypermedia.net.*;


UDP udp;

void setup() {
  background(255,0,0);
  
  udp = new UDP( this, 6000 );

  udp.listen( true );
}

void draw() {;}

void keyPressed() {
    
    String message  = str( key );
    String ip       = "127.0.0.1";
    int port        = 6100;
    
    message = message+";\n";
    
    udp.send( message, ip, port );
    
}

void receive( byte[] data, String ip, int port ) {
  
  data = subset(data, 0, data.length-2);
  String message = new String( data );
  
  println( "Recebido: \""+message+"\" de "+ip+" da porta "+port );
}
