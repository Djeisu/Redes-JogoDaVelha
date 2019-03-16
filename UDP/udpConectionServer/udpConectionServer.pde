//Por Djheyson Oliveira

//Código Adaptado de https://github.com/una1veritas/Processing-sketches/blob/master/libraries/udp/examples/udp/udp.pde

/*
Este é um pseudo-servidor, não encontrei documentação
sobre a forma de criar um servidor com essa biblioteca
a processing.net não tem integração com essa, então essa
não consegue obter os dados escritos pelo servidor de lá

Esse servidor tem uma porta dedicada para receber dados,
os clientes enviam dados para ela através dessa porta e
ele imprime os resultados.

obs: os dados enviados são caracteres, os caracteres
enviados pelo servidor vão para os dois clientes.
*/
import hypermedia.net.*;

UDP udp;

void setup() {
  background(0,0,255);

  udp = new UDP( this, 6100 );
  
  udp.listen( true );
}

void draw() {;}

void keyPressed() {
    
    //Enviar para o cliente 1
    String message  = str( key );
    String ip       = "127.0.0.1";
    int port        = 6000;
    
    message = message+";\n";
    
    udp.send( message, ip, port );
    
    
    //Enviar para o cliente 2
    String message2  = str( key );
    String ip2       = "127.0.0.1";
    int port2        = 6200;
    
    message2 = message2+";\n";
    
    udp.send( message2, ip2, port2 );
    
}

void receive( byte[] data, String ip, int port ) {
  
  data = subset(data, 0, data.length-2);
  String message = new String( data );
  
  println( "receive: \""+message+"\" from "+ip+" on port "+port );
  
  background(200);
}
