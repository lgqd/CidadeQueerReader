import processing.svg.*;
import java.nio.file.*;

int POINT_RADIUS = 8;
int POINT_COLOR = color(250, 0, 0);
int GLYPH_WEIGHT = 3;
int GLYPH_COLOR = color(64, 64);
int PAGE_LIMIT = 149;
String SVG_FRAME_FILE = "out/current.svg";

PImage pageImage;
PGraphics glyphGraphic, pointsGraphic;
PShape glyphShape;
ArrayList<PVector> mPoints;
int currentPage;
boolean drawPoints = true;

void setup() {
  size(546, 798);

  mPoints = new ArrayList<PVector>();
  currentPage = 0;
  pageImage = loadImage(dataPath("queer_leitora"+pad(currentPage)+".jpg"));
  pointsGraphic = createGraphics(width, height);
  glyphGraphic = createGraphics(width, height, SVG, dataPath(SVG_FRAME_FILE));
  generateGlyph();
}

void draw() {
  background(200);
  image(pageImage, 0, 0);
  if (drawPoints) {
    image(pointsGraphic, 0, 0);
  }
  shape(glyphShape, 0, 0);
}

void drawPointsOnGraphic() {
  pointsGraphic.beginDraw();
  pointsGraphic.background(255, 0);
  pointsGraphic.fill(POINT_COLOR);
  pointsGraphic.noStroke();
  for (int i=0; i<mPoints.size (); i++) {
    pointsGraphic.ellipse(mPoints.get(i).x, mPoints.get(i).y, POINT_RADIUS, POINT_RADIUS);
  }
  pointsGraphic.endDraw();
}

void generateGlyph() {
  glyphGraphic.beginDraw();
  glyphGraphic.smooth();
  glyphGraphic.noFill();
  glyphGraphic.stroke(GLYPH_COLOR);
  glyphGraphic.strokeWeight(GLYPH_WEIGHT);

  ArrayList<PVector> somePoints = new ArrayList<PVector>();
  for (int i=0; i<10 && mPoints.size ()>0; i++) {
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
      glyphGraphic.bezier(tPoints[0].x, tPoints[0].y, 
        tPoints[1].x, tPoints[1].y, 
        tPoints[2].x, tPoints[2].y, 
        tPoints[3].x, tPoints[3].y);
    } else if (mR < 0.6) {
      glyphGraphic.line(tPoints[0].x, tPoints[0].y, tPoints[1].x, tPoints[1].y);
      glyphGraphic.line(tPoints[2].x, tPoints[2].y, tPoints[1].x, tPoints[1].y);
    } else if (mR < 0.8) {
      glyphGraphic.ellipse(tPoints[0].x, tPoints[0].y, tPoints[0].dist(tPoints[1])/2, tPoints[0].dist(tPoints[2])/2);
    } else {
      float arcAngleStart = PVector.angleBetween(tPoints[0], tPoints[3]);
      float arcAngleStop = arcAngleStart + random(PI/4, PI);
      glyphGraphic.arc(tPoints[0].x, tPoints[0].y, 
        tPoints[0].dist(tPoints[1])/2, tPoints[0].dist(tPoints[2])/2, 
        arcAngleStart, arcAngleStop);
    }
  }

  glyphGraphic.endDraw();
  glyphShape = loadShape(dataPath(SVG_FRAME_FILE));
}

void mouseReleased() {
  PVector mClick = new PVector(mouseX, mouseY);
  for (int i=0; i<mPoints.size (); i++) {
    if (mPoints.get(i).dist(mClick) < POINT_RADIUS) {
      mPoints.remove(i);
      drawPointsOnGraphic();
      return;
    }
  }
  mPoints.add(mClick);
  drawPointsOnGraphic();
}

void clearGlyph() {
  glyphGraphic.beginDraw();
  glyphGraphic.endDraw();
  glyphShape = loadShape(dataPath(SVG_FRAME_FILE));
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == UP) {
      currentPage = min((currentPage + 1), (PAGE_LIMIT - 1));
      pageImage = loadImage(dataPath("queer_leitora"+pad(currentPage)+".jpg"));
      mPoints.clear();
      drawPointsOnGraphic();
      clearGlyph();
    } else if (keyCode == DOWN) {
      currentPage = max((currentPage - 1), 0);
      pageImage = loadImage(dataPath("queer_leitora"+pad(currentPage)+".jpg"));
      mPoints.clear();
      drawPointsOnGraphic();
      clearGlyph();
    } else if (keyCode == LEFT || keyCode == RIGHT) {
      if (mPoints.isEmpty()) {
      }
      generateGlyph();
    }
  } else if (key == 'p') {
    drawPoints = !drawPoints;
  } else if (key == ' ') {
    saveSVG();
    savePoints();
  }
}

void saveSVG() {
  Path src = Paths.get(dataPath(SVG_FRAME_FILE));
  Path dst = Paths.get(dataPath("out/queer_leitora"+pad(currentPage+1)+"_"+frameCount+".svg"));
  try {
    Files.copy(src, dst);
  } 
  catch(Exception e) {
    println(e);
  }
}

void savePoints() {
  String[] s = new String[1];
  s[0] = "";
  for (int i=0; i<mPoints.size (); i++) {
    s[0] += "mPoints.add(new PVector("+mPoints.get(i).x+", "+mPoints.get(i).y+"));\n";
  }
  saveStrings(dataPath("out/queer_leitora"+pad(currentPage+1)+"_"+frameCount+".txt"), s);
}

String pad(int i, int l) {
  String s = Integer.toString(i);
  while (s.length () < l) {
    s = "0"+s;
  }
  return s;
}

String pad(int i) {
  return pad(i, 3);
}