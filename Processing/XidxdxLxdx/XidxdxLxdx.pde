int POINT_RADIUS = 12;
int POINT_COLOR = color(32);
int GLYPH_WEIGHT = 8;
int GLYPH_COLOR = color(0);
//int GLYPH_COLOR = color(255);
//int GLYPH_COLOR = color(1, 69, 79);

Map mMap;
PGraphics mGlyph;
ArrayList<PVector> mPoints;
ArrayList<Map> mMaps;
int currentMap;

void setup() {
  size(1200, 680);

  mPoints = new ArrayList<PVector>();
  mMaps = new ArrayList<Map>();
  mMaps.add(new CidadeMap("cidade.png"));
  mMaps.add(new LindaMap("linda.png"));
  mMaps.add(new QueerMap("queer.png"));
  mMaps.add(new BlankMap("blank.png"));
  currentMap = 0;
  mMap = mMaps.get(currentMap);
  mMap.addPoints(mPoints);

  mGlyph = createGraphics((int)(2*width), (int)(2*height));
}

void draw() {
  background(200);
  mMap.draw(0, 0);

  fill(POINT_COLOR);
  noStroke();
  for (int i=0; i<mPoints.size(); i++) {
    ellipse(mPoints.get(i).x, mPoints.get(i).y, POINT_RADIUS, POINT_RADIUS);
  }

  image(mGlyph, -(mGlyph.width-width)/2, -(mGlyph.height-height)/2);
}

void generateGlyph() {
  mGlyph.beginDraw();
  mGlyph.smooth();
  mGlyph.pushMatrix();
  mGlyph.translate((mGlyph.width-width)/2, (mGlyph.height-height)/2);
  mGlyph.background(255, 0);
  mGlyph.noFill();
  mGlyph.stroke(GLYPH_COLOR);
  mGlyph.strokeWeight(GLYPH_WEIGHT);

  ArrayList<PVector> somePoints = new ArrayList<PVector>();
  for (int i=0; i<10 && mPoints.size()>0; i++) {
    somePoints.add(mPoints.get((int)random(mPoints.size())));
  }

  int numberOfLines = (int) random(0.5*somePoints.size(), 0.75*somePoints.size());

  for (int i=0; i<numberOfLines; i++) {
    PVector[] tPoints = new PVector[4];
    tPoints[0] = somePoints.get((int)random(somePoints.size()));
    tPoints[1] = somePoints.get((int)random(somePoints.size()));
    tPoints[2] = somePoints.get((int)random(somePoints.size()));
    tPoints[3] = somePoints.get((int)random(somePoints.size()));

    float mR = random(1); 
    if (mR < 0.4) {
      mGlyph.bezier(tPoints[0].x, tPoints[0].y, 
        tPoints[1].x, tPoints[1].y, 
        tPoints[2].x, tPoints[2].y, 
        tPoints[3].x, tPoints[3].y);
    } else if (mR < 0.6) {
      mGlyph.line(tPoints[0].x, tPoints[0].y, tPoints[1].x, tPoints[1].y);
      mGlyph.line(tPoints[2].x, tPoints[2].y, tPoints[1].x, tPoints[1].y);
    } else if (mR < 0.8) {
      mGlyph.ellipse(tPoints[0].x, tPoints[0].y, tPoints[0].dist(tPoints[1])/2, tPoints[0].dist(tPoints[2])/2);
    } else {
      float arcAngleStart = PVector.angleBetween(tPoints[0], tPoints[3]);
      float arcAngleStop = arcAngleStart + random(PI/4, PI);
      mGlyph.arc(tPoints[0].x, tPoints[0].y, 
        tPoints[0].dist(tPoints[1])/2, tPoints[0].dist(tPoints[2])/2, 
        arcAngleStart, arcAngleStop);
    }
  }

  mGlyph.popMatrix();
  mGlyph.endDraw();
}

void mouseReleased() {
  PVector mClick = new PVector(mouseX, mouseY);
  for (int i=0; i<mPoints.size(); i++) {
    if (mPoints.get(i).dist(mClick) < POINT_RADIUS) {
      mPoints.remove(i);
      return;
    }
  }
  mPoints.add(mClick);
}

void clearGlyph() {
  mGlyph.beginDraw();
  mGlyph.background(255, 0);
  mGlyph.endDraw();
}
void keyReleased() {
  if (key == CODED) {
    if (keyCode == UP) {
      currentMap = min((currentMap + 1), (mMaps.size() - 1));
      mMap = mMaps.get(currentMap);
      mMap.addPoints(mPoints);
      clearGlyph();
    } else if (keyCode == DOWN) {
      currentMap = max((currentMap - 1), 0);
      mMap = mMaps.get(currentMap);
      mMap.addPoints(mPoints);
      clearGlyph();
    } else if (keyCode == LEFT || keyCode == RIGHT) {
      if (mPoints.isEmpty()) {
        mMap.addPoints(mPoints);
      }
      generateGlyph();
    }
  } else if (key == ' ') {
    mGlyph.filter(INVERT);
    mGlyph.save(dataPath("out/"+mMap.name()+millis()+second()+".jpg"));
    mGlyph.filter(INVERT);
  }
}