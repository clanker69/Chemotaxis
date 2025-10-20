// Chemotaxis + SnakeHead (touches both edges + faster chemo)
Bacteria[] colony;
int num = 50;
float bias = 0.25f;
SnakeHead snake;

void setup() {
  size(800, 600);
  noStroke();

  colony = new Bacteria[num];
  for (int i = 0; i < num; i++) {
    colony[i] = new Bacteria(width/2, height/2);
  }

  // place snake so its body touches bottom and right edges
  snake = new SnakeHead(width - 30, height + 3);
}

void draw() {
  background(0);

  // move and draw bacteria
  for (Bacteria b : colony) {
    b.move(mouseX, mouseY, bias);
    b.show();
  }

  // draw snake head
  snake.show();

  // check collision with bacteria
  for (Bacteria b : colony) {
    if (!snake.dead && snake.touches(b)) {
      snake.die();
    }
  }
}

// ----------------- Classes -----------------

class Bacteria {
  int x, y, c;

  Bacteria(int startX, int startY) {
    x = startX;
    y = startY;
    c = color((int)(Math.random() * 255), (int)(Math.random() * 255), (int)(Math.random() * 255));
  }

  void move(float targetX, float targetY, float biasToward) {
    float speed = 3.5f; // faster chemo
    if (Math.random() < biasToward) {
      float dx = targetX - x;
      float dy = targetY - y;
      float distToTarget = dist(x, y, targetX, targetY);
      if (distToTarget != 0) {
        x += (int)((dx / distToTarget) * speed);
        y += (int)((dy / distToTarget) * speed);
      }
    } else {
      x += (int)(Math.random() * 5 - 2);
      y += (int)(Math.random() * 5 - 2);
    }

    // wrap around
    if (x < 0) x = width;
    if (x > width) x = 0;
    if (y < 0) y = height;
    if (y > height) y = 0;
  }

  void show() {
    fill(c);
    ellipse(x, y, 8, 8);
  }
}

class SnakeHead {
  float x, y;
  boolean dead = false;
  color c = color(0, 200, 0);

  SnakeHead(float startX, float startY) {
    x = startX;
    y = startY;
  }

  void show() {
    if (dead) c = color(200, 0, 0);
    fill(c);
    noStroke();
    // half ellipse head — touches both bottom + right edges
    arc(x, y, 60, 60, PI, TWO_PI);
    // eyes
    fill(255);
    ellipse(x - 15, y - 10, 15, 15);
    ellipse(x + 15, y - 10, 15, 15);
    fill(0);
    ellipse(x - 15, y - 10, 7, 7);
    ellipse(x + 15, y - 10, 7, 7);
    // smile :)
    noFill();
    stroke(0);
    strokeWeight(2);
    arc(x, y + 5, 25, 15, 0, PI);
  }

  boolean touches(Bacteria b) {
    return dist(x, y, b.x, b.y) < 30;
  }

  void die() {
    dead = true;
  }
}
