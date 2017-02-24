import processing.svg.*;
import java.nio.file.*;

int POINT_RADIUS = 8;
int POINT_COLOR = color(255, 0, 0);
int GLYPH_WEIGHT = 3;
int GLYPH_COLOR = color(64, 64);
int PAGE_LIMIT = 149;
String GLYPH_LINES_FILE = "out/lines.svg";
String GLYPH_POINTS_FILE = "out/points.svg";

PImage pageImage;
PGraphics pointsGraphic, glyphLines, glyphPoints;
PShape glyphLinesShape, glyphPointsShape;
ArrayList<PVector> mPoints;
ArrayList<String> mPages;
int currentPage;
boolean drawPoints = true;

void setup() {
  size(493, 740);

  mPoints = new ArrayList<PVector>();
  mPages = new ArrayList<String>();

  File[] fs = (new File(dataPath(""))).listFiles();
  for (int i=0; i<fs.length; i++) {
    if (fs[i].isFile() && fs[i].getName().endsWith(".jpg")) {
      if (fs[i].getName().startsWith("x")) {
        mPages.add(fs[i].getName());
      }
    }
  }

  currentPage = 0;
  pageImage = loadImage(dataPath(mPages.get(currentPage)));
  pointsGraphic = createGraphics(width, height);
  glyphPoints = createGraphics(width, height, SVG, dataPath(GLYPH_POINTS_FILE));
  glyphLines = createGraphics(width, height, SVG, dataPath(GLYPH_LINES_FILE));
  generateGlyph();
}

void draw() {
  background(200);
  image(pageImage, 0, 0);
  if (drawPoints) {
    image(pointsGraphic, 0, 0);
  }
  shape(glyphPointsShape, 0, 0);
  shape(glyphLinesShape, 0, 0);
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
  generatePoints();
  generateLines();
}

void generatePoints() {
  glyphPoints.beginDraw();
  glyphPoints.smooth();
  glyphPoints.noFill();
  glyphPoints.stroke(GLYPH_COLOR);

  glyphPoints.point(0, 0);
  glyphPoints.point(width, height);

  glyphPoints.fill(GLYPH_COLOR);
  glyphPoints.noStroke();
  for (int i=0; i<mPoints.size (); i++) {
    glyphPoints.ellipse(mPoints.get(i).x, mPoints.get(i).y, POINT_RADIUS, POINT_RADIUS);
  }

  glyphPoints.endDraw();
  glyphPointsShape = loadShape(dataPath(GLYPH_POINTS_FILE));
}

void generateLines() {
  glyphLines.beginDraw();
  glyphLines.smooth();
  glyphLines.noFill();
  glyphLines.stroke(GLYPH_COLOR);
  glyphLines.strokeWeight(GLYPH_WEIGHT);

  glyphLines.point(0, 0);
  glyphLines.point(width, height);

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
      glyphLines.bezier(tPoints[0].x, tPoints[0].y, 
        tPoints[1].x, tPoints[1].y, 
        tPoints[2].x, tPoints[2].y, 
        tPoints[3].x, tPoints[3].y);
    } else if (mR < 0.6) {
      glyphLines.line(tPoints[0].x, tPoints[0].y, tPoints[1].x, tPoints[1].y);
      glyphLines.line(tPoints[2].x, tPoints[2].y, tPoints[1].x, tPoints[1].y);
    } else if (mR < 0.8) {
      glyphLines.ellipse(tPoints[0].x, tPoints[0].y, tPoints[0].dist(tPoints[1])/2, tPoints[0].dist(tPoints[2])/2);
    } else {
      float arcAngleStart = PVector.angleBetween(tPoints[0], tPoints[3]);
      float arcAngleStop = arcAngleStart + random(PI/4, PI);
      glyphLines.arc(tPoints[0].x, tPoints[0].y, 
        tPoints[0].dist(tPoints[1])/2, tPoints[0].dist(tPoints[2])/2, 
        arcAngleStart, arcAngleStop);
    }
  }

  glyphLines.endDraw();
  glyphLinesShape = loadShape(dataPath(GLYPH_LINES_FILE));
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
  glyphPoints.beginDraw();
  glyphPoints.endDraw();
  glyphPointsShape = loadShape(dataPath(GLYPH_POINTS_FILE));
  glyphLines.beginDraw();
  glyphLines.endDraw();
  glyphLinesShape = loadShape(dataPath(GLYPH_LINES_FILE));
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == UP) {
      currentPage = min((currentPage + 1), mPages.size() - 1);
      pageImage = loadImage(dataPath(mPages.get(currentPage)));
      mPoints.clear();
      drawPointsOnGraphic();
      clearGlyph();
    } else if (keyCode == DOWN) {
      currentPage = max((currentPage - 1), 0);
      pageImage = loadImage(dataPath(mPages.get(currentPage)));
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
  }
}

void saveSVG() {
  String outFile = "out/"+mPages.get(currentPage).replace(".jpg", "")+"_X!X!_"+frameCount+".svg";
  Path pointsSrc = Paths.get(dataPath(GLYPH_POINTS_FILE));
  Path pointsDst = Paths.get(dataPath(outFile.replace("X!X!", "points")));
  Path linesSrc = Paths.get(dataPath(GLYPH_LINES_FILE));
  Path linesDst = Paths.get(dataPath(outFile.replace("X!X!", "lines")));
  try {
    Files.copy(pointsSrc, pointsDst);
    Files.copy(linesSrc, linesDst);
  } 
  catch(Exception e) {
    println(e);
  }
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