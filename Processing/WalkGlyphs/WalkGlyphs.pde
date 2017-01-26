public enum State { 
  SELECT, GENERATE
}

int POINT_RADIUS = 10;

Map mMap;
PGraphics mGlyph;
ArrayList<PVector> mPoints;
ArrayList<Map> mMaps;
int currentMap;
State mState; 

void setup() {
  size(1200, 680);

  mPoints = new ArrayList<PVector>();
  mMaps = new ArrayList<Map>();
  mMaps.add(new CidadeMap("cidade.png"));
  mMaps.add(new LindaMap("linda.png"));
  mMaps.add(new QueerMap("queer.png"));
  currentMap = 0;
  mMap = mMaps.get(currentMap);
  mMap.addPoints(mPoints);

  mGlyph = createGraphics((int)(2*width), (int)(2*height));
  mState = State.SELECT;
}

void draw() {
  if (mState == State.SELECT) {
    SELECTdraw();
  } else if (mState == State.GENERATE) {
    GENERATEdraw();
  }
}

void SELECTdraw() {
  background(200);
  mMap.draw(0, 0);

  fill(200, 100, 100);
  noStroke();
  for (int i=0; i<mPoints.size(); i++) {
    ellipse(mPoints.get(i).x, mPoints.get(i).y, 2*POINT_RADIUS, 2*POINT_RADIUS);
  }
}

void GENERATEdraw() {
  background(0);
  image(mGlyph, 0, 0, width, height);
}

void generateGlyph() {
  mGlyph.beginDraw();
  mGlyph.pushMatrix();
  mGlyph.translate((mGlyph.width-width)/2, (mGlyph.height-height)/2);
  mGlyph.background(0, 0);
  mGlyph.stroke(255);
  mGlyph.strokeWeight(20);
  mGlyph.noFill();

  int numberOfLines = (int) random(5, 9);
  for (int i=0; i<numberOfLines; i++) {
    PVector[] tPoints = new PVector[4];
    tPoints[0] = mPoints.get((int)random(mPoints.size()));
    tPoints[1] = mPoints.get((int)random(mPoints.size()));
    tPoints[2] = mPoints.get((int)random(mPoints.size()));
    tPoints[3] = mPoints.get((int)random(mPoints.size()));

    float mR = random(1); 
    if (mR < 0.33) {
      mGlyph.bezier(tPoints[0].x, tPoints[0].y, 
        tPoints[1].x, tPoints[1].y, 
        tPoints[2].x, tPoints[2].y, 
        tPoints[3].x, tPoints[3].y);
    } else if (mR < 0.66) {
      mGlyph.line(tPoints[0].x, tPoints[0].y, tPoints[1].x, tPoints[1].y);
    } else if (mR < 0.82) {
      mGlyph.ellipse(tPoints[0].x, tPoints[0].y, tPoints[0].dist(tPoints[1])/2, tPoints[0].dist(tPoints[2])/2);
    } else {
      mGlyph.arc(tPoints[0].x, tPoints[0].y, 
        tPoints[0].dist(tPoints[1])/2, tPoints[0].dist(tPoints[2])/2, 
        PVector.angleBetween(tPoints[0], tPoints[3]), PVector.angleBetween(tPoints[0], tPoints[1]));
    }
  }

  mGlyph.popMatrix();
  mGlyph.endDraw();
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == UP) {
      currentMap = min((currentMap + 1), (mMaps.size() - 1));
      mMap = mMaps.get(currentMap);
      mMap.addPoints(mPoints);
      mState = State.SELECT;
    } else if (keyCode == DOWN) {
      currentMap = max((currentMap - 1), 0);
      mMap = mMaps.get(currentMap);
      mMap.addPoints(mPoints);
      mState = State.SELECT;
    } else if (keyCode == LEFT || keyCode == RIGHT) {
      if (mPoints.isEmpty()) {
        mMap.addPoints(mPoints);
      }
      mState = State.GENERATE;
      generateGlyph();
    }
  } else if (key == ' ') {
    if (mState == State.GENERATE) {
      mGlyph.save(dataPath("out/"+mMap.name()+millis()+second()+".jpg"));
    }
  }
}