/* Modified from renaud's "Snakes are hunting You" sketch at http://www.openprocessing.org/visuals/?visualID=1252 */

class AttractorB {
  int N = 1;
  PVector[] p = new PVector[N];
  float[] A = new float[N];
  float[] R = new float[N];
  float[] v = new float[N];
  color colour;
  float xb,yb;
  float v0;
  float O0;
  float a=random(1,10);
  PVector start;
  boolean isDead;

  AttractorB (PVector _start, color c, float radius) {
    isDead = false;
    colour = c;
    p[0] = new PVector(_start.x, _start.y);
    R[0] = radius;
    A[0] = PVector.angleBetween(_start, dest); 
    v[0] = 0;
    v0 = random(3,5);
    O0 = random(0.1, 1);
    for (int i = 1; i < N; i++) {
      A[i] = A[0];
      R[i] = R[0] * exp(-float(i)/(N));
      p[i] = new PVector(p[i-1].x + cos(A[i]) * 1, p[i-1].y + sin(A[i]) * 1);
      v[i] = 0;
    }
  }

  void update() {
    PVector pb = new PVector();
    pb.set(dest);
    for (int i = 0; i < N; i++) {
      A[i] = angle(pb.x, pb.y, p[i].x, p[i].y);
      if (i == 0) {
        A[i] += O0 * sin(millis() / (100 * a));        
      }
      float s = PVector.dist(dest, p[i]);
      if (s > 1) {
        v[i] = v0 * (1-exp(1-s));
      } else {
        v[i] = 0;
        isDead = true;
      }
      p[i].x = p[i].x + v[i]*cos(A[i]);
      p[i].y = p[i].y + v[i]*sin(A[i]);
      pb.set(p[i]);      
    }
  }
  
  void draw() {
    for (int i = 0; i < N; i++) {
      noStroke();
      fill(colour);
      ellipse(p[i].x, p[i].y, R[i], R[i]);
    }
  }
}

float angle(float x0,float y0,float x1,float y1) {
  float A=atan((y1-y0)/(x1-x0));
  if ((x1-x0)<0) {
   A=A+PI;
  }
  A=A+PI;
  return A;
}

