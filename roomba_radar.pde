byte[][] _pixels;
int[][] _pixel_ages;

int N = 50;

float x = 0.0, y = 0.0, theta = 0.0;

float min_distance = 0.0, max_distance = 15.0;
float sensor_fov = 0.5;
float sensor_distance = 0.0;


void setup() {
  size(500, 500); // N * 10
  _pixels = new byte[N][N];
  _pixel_ages = new int[N][N];
  for (int y = 0; y < N; y++) {
    for (int x = 0; x < N; x++) {
      _pixels[x][y] = 0; // not covered
      _pixel_ages[x][y] = 255;
    }
  }
}

void drawGrid() {
  background(0);
  // draw grid
  strokeWeight(5);
  for (int y = 0; y < N; y += 1) {
    for (int x = 0; x < N; x += 1) {
       _pixel_ages[x][y] =  _pixel_ages[x][y] -2 > 100 ?  _pixel_ages[x][y] - 2 : 100;
      if (_pixels[x][y] == 0) { // not covered
        stroke(color(50, 50, 50, 255));
      } else if (_pixels[x][y] == 1) { // covered free
        stroke(color(0, 255, 0, _pixel_ages[x][y]));
      } else if (_pixels[x][y] == 2) { // covered stuff
        stroke(color(255, 0, 0, _pixel_ages[x][y]));
      }
      point(x * 10, y * 10);
    }
  }
  // draw sensor
  strokeWeight(8);
  stroke(color(255, 255, 0));
  point((x + (N/2)) * 10, (y + (N/2)) * 10);

  noFill();
  strokeWeight(2);
  stroke(color(255, 255, 255));
  
  float _from_theta = theta - (sensor_fov/2) ;
  float _to_theta =  theta + (sensor_fov/2) ;
  
  //ellipse((x + (N/2)) * 10, (y + (N/2)) * 10, max_distance* 10*2, max_distance* 10*2);
  arc((x + (N/2)) * 10, (y + (N/2)) * 10, max_distance* 10*2, max_distance* 10*2, _from_theta, _to_theta);
  
  //ellipse((x + (N/2)) * 10, (y + (N/2)) * 10, int(sensor_distance)* 10*2, int(sensor_distance)* 10*2);
  arc((x + (N/2)) * 10, (y + (N/2)) * 10, int(sensor_distance)* 10*2, int(sensor_distance)* 10*2, _from_theta, _to_theta);

  float __x = int(max_distance * cos(theta-sensor_fov/2));
  float __y = int(max_distance * sin(theta-sensor_fov/2));
  line(
    (x + (N/2)) * 10,
    (y + (N/2)) * 10,
    (x + __x + (N/2)) * 10,
    (y +__y  +(N/2)) * 10  );

  __x = int(max_distance * cos(theta+sensor_fov/2));
  __y = int(max_distance * sin(theta+sensor_fov/2));
  line(
    (x + (N/2)) * 10,
    (y + (N/2)) * 10,
    (x + __x + (N/2)) * 10,
    (y +__y  +(N/2)) * 10  );
}

void draw() {

  x += ( random(1.0)  ) - .5;
  y += ( random(1.0) ) - .5;
  theta += ( random(1.0) ) - .5;


  /*x += ( noise(x+0.1, y+0.1, theta+0.1)  ) - .5;
   y += ( noise(theta+0.1, x+0.1, y+0.1) ) - .5;
   theta += ( noise(y+0.1, theta+0.1, x+0.1) ) - .5;*/

  //sensor_distance = int((random(1.0) * (max_distance-min_distance))+min_distance);
  sensor_distance = int((noise(x, y, theta) * (max_distance-min_distance))+min_distance);

  // free
  for (float r = min_distance*10; r < sensor_distance*10; r++) {
    for (float alpha = int(theta-sensor_fov/2)*10; alpha < int(theta+sensor_fov/2)*10; alpha++) {
      int _x = int(x + (r/10) * cos(alpha/10)) + (N/2);
      int _y = int(y + (r/10) * sin(alpha/10)) + (N/2);
      _pixels[_x][_y] = 1; // covered free
      _pixel_ages[_x][_y] = 255; // new
    }
  }

  // stuff
  for (float r = sensor_distance*10; r < max_distance*10; r++) {
    for (float alpha = int(theta-sensor_fov/2)*10; alpha < int(theta+sensor_fov/2)*10; alpha++) {
      int _x = int(x + (r/10) * cos(alpha/10.0)) + (N/2);
      int _y = int(y + (r/10) * sin(alpha/10.0)) + (N/2);
      _pixels[_x][_y] = 2; // covered stuff
      _pixel_ages[_x][_y] = 255; // new
    }
  }

  drawGrid();

  delay(150);
}
