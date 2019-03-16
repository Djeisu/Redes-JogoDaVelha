import processing.net.*;

Server s; 
Client c;
String input;
int data[];

Mapa map;
int vez;

void setup() {
  size(301, 301);
  s = new Server(this, 12345);  // Start a simple server on a port
  map = new Mapa();
  vez = 2;
  background(220);
}

void draw() {
  map.mapa_draw();
  map.mapa_colid();
  
  
  if(map.mapa_vitoria()){
    if(data[0] == 1){
      println("Quadrado Ganhou");
    }
    if(data[0] == 2){
      println("Circulo Ganhou");
    }
  }
}

class Mapa {

  ArrayList<PVector> x;
  ArrayList<PVector> y;
  PVector centro;

  Mapa() {
    centro = new PVector((300/3)/2, (300/3)/2);
    x = new ArrayList<PVector>();

    for (int i = 0; i < 9; i++) {
      PVector p;
      if (i < 3)  p = new PVector((centro.x*2)*i, 0);
      else if (i >= 3 && i < 6) p = new PVector((centro.x*2)*(i%3), centro.y*2);
      else p = new PVector((centro.x*2)*(i%3), centro.y*4);

      x.add(p);
    }
  }

  void mapa_draw() {
    // Receive data from client
    c = s.available();
    if (c != null) {
      x = new ArrayList<PVector>();
      input = c.readString();
      input = input.substring(0, input.indexOf("\n"));  // Only up to the newline
      data = int(split(input, ' '));  // Split values into an array

      print(data[0] + " val ");
      vez = data[0];
      for (int j = 0; j < data.length; j++) {
        print(data[j] + " ");
        if ((j-1)%3 == 0 && j != 0) {
          PVector p = new PVector(data[j], data[j+1], data[j+2]);
          x.add(p);
        }
      }
    }

    String valServer = vez + " ";
    for (int i = 0; i < 9; i++) {
      PVector p = x.get(i);
      if (i%3!=0) {
        stroke(190);
        line(p.x, 0, p.x, 300);
        line(0, p.y, 300, p.y);
      }

      if (i < 8)
        valServer += int(p.x) + " " + int(p.y) + " " + int(p.z) + " ";
      else
        valServer += int(p.x) + " " + int(p.y) + " " + int(p.z) + "\n";
    }

    s.write(valServer);
  }

  void mapa_colid() {
    //if (m_pressed) {
    //    for (int j = 0; j < 9; j++) {
    //      PVector p = x.get(j);
    //      p.z = 0;
    //      x.add(p);
    //    }
    //    m_pressed = false;
    //  }

    for (int i = 0; i < 9; i++) {
      PVector pX = x.get(i);
      if (pX.z == 1) {
        fill(235, 62, 74);
        noStroke();
        rectMode(CENTER);
        rect(pX.x+50, pX.y+50, 30, 30);
      }

      if (pX.z == 2) {
        fill(33, 190, 218);
        noStroke();
        rectMode(CENTER);
        ellipse(pX.x+50, pX.y+50, 30, 30);
      }
    }
  }

  boolean mapa_vitoria() {
    if (!mapa_velha())
    {
      if ( x.get(0).z == x.get(1).z && x.get(0).z == x.get(2).z && x.get(0).z != 0){
        println("Venceu primeira linha");
        return true;
      }

      if ( x.get(3).z == x.get(4).z && x.get(3).z == x.get(5).z && x.get(3).z != 0){
        println("Venceu segunda linha");
        return true;
      }

      if ( x.get(6).z == x.get(7).z && x.get(6).z == x.get(2).z && x.get(6).z != 0){
        println("Venceu terceira linha");
        return true;
      }

      if ( x.get(0).z == x.get(3).z && x.get(0).z == x.get(6).z && x.get(0).z != 0){
        println("Venceu primiera coluna");
        return true;
      }

      if ( x.get(1).z == x.get(4).z && x.get(1).z == x.get(7).z && x.get(1).z != 0){
        println("Venceu segunda coluna");
        return true;
      }

      if ( x.get(2).z == x.get(5).z && x.get(2).z == x.get(8).z && x.get(2).z != 0){
        println("Venceu terceira coluna");
        return true;
      }

      if ( x.get(0).z == x.get(4).z && x.get(0).z == x.get(8).z && x.get(0).z != 0){
        println("Venceu diagonal cima baixo");
        return true;
      }

      if ( x.get(6).z == x.get(4).z && x.get(6).z == x.get(2).z && x.get(6).z != 0){
        println("Venceu diagonal baixo cima");
        return true;
      }
      
    }else{
      println("Velha");
      return true;
    }
    
    return false;
  }

  boolean mapa_velha() {
    for (int i = 0; i < x.size(); i++) {
      PVector p = x.get(i);
      if (p.z == 0)
        return false;
    }
    return true;
  }
}

boolean m_pressed = false;

void mouseReleased() {
  m_pressed = true;
}
