int blockSize = 20;// segment size of snake
int cols, rows;// number of grid columns and rows
ArrayList<PVector> snake; // array --> to store segments
PVector food;// food random position
int xSpeed = 1, ySpeed = 0; //vairable  created to control the snake speed at x and y axis 
int score = 0; // Score tracker

void setup() {
  size(640, 480);
  frameRate(10);          
  cols = width / blockSize;// Calculate grid size
  rows = height / blockSize;
  resetGame();// Initialize the game
}

void draw() {
  drawBackground();// for colorful gradient and patterns
   fill(255); 
  textSize(16);
  text("Muhammad Umair Qureshi",9,35);
  text("Matriculation# 22406769",9,55);
  displayPosition();
  moveSnake();// snake movement 
  checkFood();// food collision
  checkCollisions();// Check for wall and self collisions
  drawSnake();// draw the snake
  drawFood();// draw food
  displayScore();// score display
  drawArrow(); // arrow display

}

void resetGame() {
  snake = new ArrayList<PVector>();// setting up a list to keep track of each part of the snakes body---->represented by a PVector (x, y position)
  snake.add(new PVector(cols / 2, rows / 2));// start snake in the center
  spawnFood();// Spawn the first food
  xSpeed = 1;
  ySpeed = 0;
  score = 0;
}

void drawBackground() {
  // create a gradient background from top to bottom
  for (int y = 0; y < height; y++) {
    float inter = map(y, 0, height, 0, 1);// gradually blend colors as we go down
    int c = lerpColor(color(60, 90, 170), color(30, 50, 120), inter); //transition from light to dark blue
    stroke(c);
    line(0, y, width, y);//draw each line across the screen
  }

  // loop to add circular patterns
  for (int i = 0; i < 8; i++) {
    float x = random(width);
    float y = random(height);
    fill(255, 255, 255, 30);
    ellipse(x, y, 100, 100);
  }
  
  // Grid overlay for visual interest
  stroke(255, 50);
  for (int i = 0; i < cols; i++) {
    line(i * blockSize, 0, i * blockSize, height);
  }
  for (int i = 0; i < rows; i++) {
    line(0, i * blockSize, width, i * blockSize);
  }
}

void moveSnake() {
  PVector head = snake.get(0).copy();
  head.x += xSpeed;
  head.y += ySpeed;
  snake.add(0, head);//add new head to the front of the snake
  if (head.dist(food) > 0.1) {
    snake.remove(snake.size() - 1); //remove the last segment ---> no food eaten
  }
}
void displayPosition() {
  PVector head = snake.get(0); // Get the head position
  fill(255);
  textSize(16);
  text("Head Position: (" + int(head.x) + ", " + int(head.y) + ")", 10, height - 10);
}
void drawArrow() {
  PVector head = snake.get(0); // Get the head position
  float arrowSize = 10; // Size of the arrow

  // Calculate the position for the arrow tip
  float arrowX = head.x * blockSize + blockSize / 2 + xSpeed * blockSize;
  float arrowY = head.y * blockSize + blockSize / 2 + ySpeed * blockSize;

  // Set arrow color and position
  fill(255, 100, 0);
  noStroke();

  // Rotate the triangle based on direction
  pushMatrix();
  translate(arrowX, arrowY);
  
  if (xSpeed == 1) { // Right
    rotate(0);
  } else if (xSpeed == -1) { // Left
    rotate(PI);
  } else if (ySpeed == 1) { // Down
    rotate(HALF_PI);
  } else if (ySpeed == -1) { // Up
    rotate(-HALF_PI);
  }
  
  // Draw the arrow
  beginShape();
  vertex(-arrowSize, arrowSize / 2);
  vertex(arrowSize, 0);
  vertex(-arrowSize, -arrowSize / 2);
  endShape(CLOSE);
  popMatrix();
}


void checkFood() {
  PVector head = snake.get(0);//get the first segment of the snake, which is the head
  if (head.equals(food)) {
    score++;
    spawnFood();// new food
  }
}

void spawnFood() {
  int x = int(random(cols));
  int y = int(random(rows));
  food = new PVector(x, y);
}

void drawSnake() {
  fill(0, 255, 0);//snake color to green
  for (PVector segment : snake) {
    rect(segment.x * blockSize, segment.y * blockSize, blockSize, blockSize);//draw each segment of the snake as a square at its (x, y) position
  }
}
//new tasty pixely square fruit 
void drawFood() {
  fill(255, 0, 0);
  rect(food.x * blockSize, food.y * blockSize, blockSize, blockSize);
}
// function accessing the direction of the head of snake 
void checkCollisions() {
  PVector head = snake.get(0);
  
  // Check wall collisions :P -----------primary wall collisions head head 
  if (head.x < 0 || head.x >= cols || head.y < 0 || head.y >= rows) {
    resetGame();
  }
  
  // Check self-collision---> when snake bites itself  >> game reset >> ///resized snake to 1
  for (int i = 1; i < snake.size(); i++) {
    if (head.equals(snake.get(i))) {
      resetGame();
    }
  }
}
//score display set on the left upper>>> increment when snake eat the square fruit 
void displayScore() {
  fill(255); 
  textSize(16);
  text("Score: " + score, 10, 20);
}

void keyPressed() {
  // Set snake direction based on arrow keys ---> no w s d a just arrow keys
  if (keyCode == UP && ySpeed == 0) {
    xSpeed = 0;
    ySpeed = -1;
  } else if (keyCode == DOWN && ySpeed == 0) {
    xSpeed = 0;
    ySpeed = 1;
  } else if (keyCode == LEFT && xSpeed == 0) {
    xSpeed = -1;
    ySpeed = 0;
  } else if (keyCode == RIGHT && xSpeed == 0) {
    xSpeed = 1;
    ySpeed = 0;
  }
}
