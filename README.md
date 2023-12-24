# Creative-Coding-12.24-Homework
That is wise. Were I to invoke logic, however, logic clearly dictates that the needs of the many outweigh the needs of the few.
— Spock

A particle system is a collection of many many minute particles that together represent a fuzzy object. Over a period of time, particles are generated into a system, move and change from within the system, and die from the system.
—William Reeves

Keywords:粒子系统；吸引力；集群

Goal：
有五种不同颜色的圆点粒子作无序运动。当颜色一样的圆点粒子相距较近时，会靠近并且吸引到一起，此时集群的粒子会增大半径，用粒子系统来模拟较为复杂的系统现象。

How to achieve：
1. 定义数组、画布、颜色等
2. 初始生成五个不同颜色的圆点，每0.1秒产生一个新的点，粒子运动速率相同
3. 检测同色粒子距离并判定是否靠近集群
4. 集群后更新半径

代码实现：

ArrayList<Ball> balls;

color[] colors = { #817C52, #315D93, #DACFC3, #FCA806, #F27984 };

void setup() {

  size(800, 600);
  
  balls = new ArrayList<Ball>();
  
  frameRate(60);
  
  // 初始生成五个不同颜色的圆点
  
  for (int i = 0; i < 5; i++) {
  
    Ball ball = new Ball(new PVector(random(width), random(height)), colors[i]);
    
    balls.add(ball);
    
  }
  
}

void draw() {

  background(255);
  
  if (frameCount % 6 == 0) {
  
    // 每0.1秒产生一个新的点
    
    Ball newBall = new Ball(new PVector(random(width), random(height)), colors[int(random(colors.length))]);
    
    balls.add(newBall);
    
  }
  
  // 按颜色升序排序
  
  balls.sort((ball1, ball2) -> Integer.compare(ball1.ballColor, ball2.ballColor));
  
  for (Ball ball : balls) {
  
    ball.move();
    
    ball.display();
    
    for (Ball other : balls) {
    
      if (ball != other && ball.ballColor == other.ballColor && ball.position.dist(other.position) < 200) {
      
        ball.follow(other);
        
      }
      
    }
    
  }
  
}

class Ball {

  PVector position;
  
  PVector velocity;
  
  int ballColor;
  
  float radius = 10;
  
  boolean isFollowing = false;
  
  Ball(PVector position, int ballColor) {
  
    this.position = position;
    
    this.velocity = PVector.random2D().mult(2);
    
    this.ballColor = ballColor;
    
  }

  void move() {
  
    position.add(velocity);

    if (position.x < 0 || position.x > width) {
    
      velocity.x *= -1;
      
    }

    if (position.y < 0 || position.y > height) {
    
      velocity.y *= -1;
      
    }
    
  }

  void display() {
  
    noStroke();
    
    fill(ballColor);
    
    ellipse(position.x, position.y, radius * 2, radius * 2);
    
  }

  void follow(Ball other) {
  
    if (!isFollowing) {
    
      isFollowing = true;
      
      // 更新半径
      
      radius += 2;
      
    }
    
    PVector direction = PVector.sub(other.position, position).normalize().mult(2);
    
    velocity.set(direction);
    
  }
  
}
