public class Points {
  private ArrayList<PVector> mPoints;
  private PVector sumOfPoints;
  private PVector averagePoint;
  private PVector standardDeviation;
  private ArrayList<ArrayList<PVector> > mQuadrants;
  private ArrayList<PVector> minDistance;
  private ArrayList<PVector> maxDistance;
  private ArrayList<PVector> quadrantMedian;

  private color[] mColors = {#ff55ff, #ffff55, #55ff55, #55ffff};

  public Points() {
    mPoints = new ArrayList<PVector>();
    mQuadrants = new ArrayList<ArrayList<PVector> >();
    minDistance = new ArrayList<PVector>();
    maxDistance = new ArrayList<PVector>();
    quadrantMedian = new ArrayList<PVector>();

    for (int i=0; i<4; i++) {
      mQuadrants.add(new ArrayList<PVector>());
      minDistance.add(new PVector(0, 0));
      maxDistance.add(new PVector(0, 0));
      quadrantMedian.add(new PVector(0, 0));
    }
    sumOfPoints = new PVector(0, 0);
    averagePoint = new PVector(0, 0);
    standardDeviation = new PVector(0, 0);
  }
  public PVector get(int i) {
    return mPoints.get(i);
  }
  public void add(PVector pv) {
    sumOfPoints.add(pv);    
    mPoints.add(pv);
    update();
  }
  public void remove(int i) {
    sumOfPoints.sub(mPoints.get(i));
    mPoints.remove(i);
    update();
  }
  public void clear() {
    sumOfPoints.set(0, 0);
    mPoints.clear();
    update();
  }
  public int size() {
    return mPoints.size();
  }
  public boolean isEmpty() {
    return mPoints.isEmpty();
  }

  private void update() {
    computeAverage();
    computeStandardDeviation();
    splitIntoQuadrants();
    computeQuadrantMedians();
  }

  private void computeAverage() {
    averagePoint.set(PVector.div(sumOfPoints, mPoints.size()));
  }

  private void computeStandardDeviation() {
    PVector variance = new PVector(0, 0);
    for (int i=0; i<mPoints.size(); i++) {
      PVector diff = PVector.sub(mPoints.get(i), averagePoint); 
      variance.add(diff.x * diff.x, diff.y * diff.y);
    }
    variance.div(mPoints.size());
    standardDeviation.set(sqrt(variance.x), sqrt(variance.y));
  }

  private void addToQuadrant(PVector pv, int quad) {
    mQuadrants.get(quad).add(pv);

    float thisDistance = PVector.dist(averagePoint, pv);
    float currentMinDistance = PVector.dist(averagePoint, minDistance.get(quad));
    float currentMaxDistance = PVector.dist(averagePoint, maxDistance.get(quad));

    if (thisDistance > currentMaxDistance) {
      maxDistance.get(quad).set(pv.x, pv.y);
    }
    if (thisDistance < currentMinDistance) {
      minDistance.get(quad).set(pv.x, pv.y);
    }
  }

  private void splitIntoQuadrants() {
    for (int i=0; i<4; i++) {
      mQuadrants.get(i).clear();
      maxDistance.get(i).set(averagePoint.x, averagePoint.y);
      minDistance.get(i).set(1e6, 1e6);
    }

    for (int i=0; i<mPoints.size(); i++) {
      PVector tv = mPoints.get(i);
      if ((tv.x <= averagePoint.x) && (tv.y <= averagePoint.y)) {
        addToQuadrant(tv, 0);
      } else if ((tv.x > averagePoint.x) && (tv.y <= averagePoint.y)) {
        addToQuadrant(tv, 1);
      } else if ((tv.x <= averagePoint.x) && (tv.y > averagePoint.y)) {
        addToQuadrant(tv, 2);
      } else {
        addToQuadrant(tv, 3);
      }
    }
  }

  private PVector computeQuadrantAverage(int quad) {
    PVector sum = new PVector(0, 0);
    ArrayList<PVector> mQuad = mQuadrants.get(quad);
    for (int i=0; i<mQuad.size(); i++) {
      sum.add(mQuad.get(i));
    }
    return sum.div(mQuad.size());
  }

  private void computeQuadrantMedian(int quad) {
    PVector median = new PVector(1e6, 1e6);
    PVector quadAvg = computeQuadrantAverage(quad);
    ArrayList<PVector> mQuad = mQuadrants.get(quad);
    for (int i=0; i<mQuad.size(); i++) {
      if (quadAvg.dist(mQuad.get(i)) < quadAvg.dist(median)) {
        median.set(mQuad.get(i));
      }
    }
    quadrantMedian.get(quad).set(median);
  }

  private void computeQuadrantMedians() {
    for (int i=0; i<quadrantMedian.size(); i++) {
      computeQuadrantMedian(i);
    }
  }

  public void draw() {
    for (int i=0; i<mQuadrants.size(); i++) {
      fill(mColors[i]);
      stroke(0);
      strokeWeight(2);
      ArrayList<PVector> tq = mQuadrants.get(i);
      for (int j=0; j<tq.size(); j++) {
        ellipse(tq.get(j).x, tq.get(j).y, POINT_RADIUS, POINT_RADIUS);
      }

      if (tq.size() > 0) {
        PVector tMedian = quadrantMedian.get(i);
        noFill();
        ellipse(tMedian.x, tMedian.y, POINT_RADIUS*3, POINT_RADIUS*3);
      }
      if (tq.size() > 1) {
        PVector tMin = minDistance.get(i);
        PVector tMax = maxDistance.get(i);
        line(tMin.x, tMin.y, tMax.x, tMax.y);
      }
    }

    fill(0);
    ellipse(averagePoint.x, averagePoint.y, POINT_RADIUS, POINT_RADIUS);
    noFill();
    ellipse(averagePoint.x, averagePoint.y, standardDeviation.x, standardDeviation.y);
  }
}