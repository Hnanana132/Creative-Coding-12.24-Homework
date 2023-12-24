ArrayList<Point> points; // 存储小圆点的数组列表
int numColors = 5; // 颜色总数
int maxPoints = 200; // 最大圆点数
int generationInterval = 60; // 圆点生成的时间间隔，单位为帧
color[] presetColors = { #817C52, #315D93, #DACFC3, #FCA806, #F27984 }; // 预设颜色
float radius = 10; // 小圆点的半径
float groupSpeed = 2; // 群体速度

void setup() {
  size(800, 600);
  points = new ArrayList<Point>();

  // 初始化五个预设颜色的点
  for (int i = 0; i < numColors; i++) {
    generatePointWithColor(presetColors[i]);
  }
}

void draw() {
  background(255);

  // 更新和绘制小圆点
  for (int i = 0; i < points.size(); i++) {
    Point p = points.get(i);
    p.update();
    p.display();
  }

  // 每隔一定帧数生成新的小圆点
  if (frameCount % generationInterval == 0 && points.size() < maxPoints) {
    generateRandomPoint();
  }
}

void generatePointWithColor(color col) {
  float x = random(width);
  float y = random(height);

  // 新生成的点的位置和颜色与同色的点一致
  PVector position = new PVector(x, y);
  PVector speed = PVector.random2D().mult(groupSpeed); // 初始速度为群体速度

  points.add(new Point(position, speed, col));
}

void generateRandomPoint() {
  // 选择一个预设颜色
  color col = presetColors[int(random(numColors))];
  
  generatePointWithColor(col);
}

class Point {
  PVector position; // 位置
  PVector speed; // 速度
  color col; // 颜色

  Point(PVector position, PVector speed, color col) {
    this.position = position;
    this.speed = speed;
    this.col = col;
  }

  void update() {
    // 更新位置
    position.add(speed);

    // 边界检测
    if (position.x < radius || position.x > width - radius) {
      speed.x *= -1;
    }
    if (position.y < radius || position.y > height - radius) {
      speed.y *= -1;
    }

    // 检测其他相同颜色的点
    for (int i = 0; i < points.size(); i++) {
      Point other = points.get(i);
      if (other != this && other.col == col) {
        float d = position.dist(other.position);
        float combinedRadius = radius * 2; // 两个小圆点的直径之和

        if (d < combinedRadius) {
          // 如果距离小于直径之和，就进行碰撞处理
          PVector direction = PVector.sub(other.position, position).normalize();
          position.sub(direction.mult(combinedRadius - d).mult(0.5)); // 避免点和点之间重叠
          speed.set(direction.mult(groupSpeed)); // 群体速度方向一致，速率一致
        }
      }
    }
  }

  void display() {
    // 绘制小圆点
    noStroke();
    fill(col);
    ellipse(position.x, position.y, radius * 2, radius * 2);
  }
}
