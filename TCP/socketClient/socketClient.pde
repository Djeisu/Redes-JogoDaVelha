import processing.net.*; 

Client c; 
String input;
int data[]; 

Mapa map;
int vez;

//ArrayList<PVector> y;

void setup() { 
  size(300, 300);
  // Connect to the server’s IP address and port­
  c = new Client(this, "127.0.0.1", 12345); // Replace with your server’s IP and port

  map = new Mapa();
  //y = new ArrayList<PVector>();
} 

void draw() { 
  background(255);

  map.mapa_draw();
  map.mapa_colid();

  if (map.mapa_vitoria() && !map.mapa_velha()) {
    if (data[0] == 1) {
      textAlign(CENTER, CENTER);
      textSize(18);
      fill(255);
      noStroke();
      rectMode(CENTER);
      rect(150, 155, 150, 35);
      fill(150);
      text( "Quadrado Ganhou", 150, 150);
    }

    if (data[0] == 2) {
      textAlign(CENTER, CENTER);
      textSize(18);
      fill(255);
      noStroke();
      rectMode(CENTER);
      rect(150, 155, 150, 35);
      fill(150);
      text( "Circulo Ganhou", 150, 150);
    }
  } else if (map.mapa_velha() && map.mapa_vitoria()) {
    textAlign(CENTER, CENTER);
    textSize(18);
    fill(0);
    noStroke();
    rectMode(CENTER);
    rect(150, 152, 150, 35);
    fill(255);
    text( "VELHA", 150, 150);
  }

  if (vez != 2 && !map.mapa_vitoria()) {
    textAlign(CENTER, CENTER);
    textSize(18);
    fill(255);
    noStroke();
    rectMode(CENTER);
    rect(150, 155, 150, 35);
    fill(150);
    text( "Aguarde Sua Vez", 150, 150);
  }
}

class Mapa {

  ArrayList<PVector> x;
  PVector centro;

  Mapa() {
    centro = new PVector((300/3)/2, (300/3)/2);
    x = new ArrayList<PVector>();

    for (int i = 0; i < 9; i++) {
      PVector p;
      if (i < 3) {
        p = new PVector((centro.x*2)*i, 0);
      } else if (i >= 3 && i < 6) {
        p = new PVector((centro.x*2)*(i%3), centro.y*2);
      } else {
        p = new PVector((centro.x*2)*(i%3), centro.y*4);
      }

      x.add(p);
    }
  }

  void mapa_draw() {
    // Receive data from server
    if (c.available() > 0) {
      x = new ArrayList<PVector>();
      input = c.readString();
      input = input.substring(0, input.indexOf("\n"));  // Only up to the newline
      data = int(split(input, ' '));  // Split values into an array

      vez = data[0];

      for (int j = 0; j < data.length; j++) {
        print(data[j] + " ");
        if ((j-1)%3 == 0 && j != 0) {
          PVector p = new PVector(data[j], data[j+1], data[j+2]);
          x.add(p);
        }
      }
    }

    for (int i = 0; i < 9; i++) {
      PVector pX = x.get(i);
      if (i%3!=0) {
        stroke(190);
        line(pX.x, 0, pX.x, 300);
        line(0, pX.y, 300, pX.y);
      }
    }
  }

  void mapa_colid() {
    for (int i = 0; i < 9; i++) {
      PVector pX = x.get(i);

      if (mouseX > pX.x && mouseX < pX.x+100 && mouseY > pX.y && mouseY < pX.y+100  && !map.mapa_vitoria())
      {
        if (m_pressed && pX.z == 0 && vez == 2) {
          pX.z = 1;

          String val = 1 + " ";
          for (int j = 0; j < 9; j++) {
            PVector p = x.get(j);

            if (j < 8)
              val += int(p.x) + " " + int(p.y) + " " + int(p.z) + " ";
            else
              val += int(p.x) + " " + int(p.y) + " " + int(p.z) + "\n";
          }

          println(val);
          c.write(val);

          m_pressed = false;
        }
      }

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
      if ( x.get(0).z == x.get(1).z && x.get(0).z == x.get(2).z && x.get(0).z != 0) {
        println("Venceu primeira linha");
        return true;
      }

      if ( x.get(3).z == x.get(4).z && x.get(3).z == x.get(5).z && x.get(3).z != 0) {
        println("Venceu segunda linha");
        return true;
      }

      if ( x.get(6).z == x.get(7).z && x.get(6).z == x.get(2).z && x.get(6).z != 0) {
        println("Venceu terceira linha");
        return true;
      }

      if ( x.get(0).z == x.get(3).z && x.get(0).z == x.get(6).z && x.get(0).z != 0) {
        println("Venceu primiera coluna");
        return true;
      }

      if ( x.get(1).z == x.get(4).z && x.get(1).z == x.get(7).z && x.get(1).z != 0) {
        println("Venceu segunda coluna");
        return true;
      }

      if ( x.get(2).z == x.get(5).z && x.get(2).z == x.get(8).z && x.get(2).z != 0) {
        println("Venceu terceira coluna");
        return true;
      }

      if ( x.get(0).z == x.get(4).z && x.get(0).z == x.get(8).z && x.get(0).z != 0) {
        println("Venceu diagonal cima baixo");
        return true;
      }

      if ( x.get(6).z == x.get(4).z && x.get(6).z == x.get(2).z && x.get(6).z != 0) {
        println("Venceu diagonal baixo cima");
        return true;
      }
    } else {
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
  if (vez == 2)
    m_pressed = true;
}
