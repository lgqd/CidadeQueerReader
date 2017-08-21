public interface Map {
  void addPoints(Points _mPoints);
  void draw(float _x, float _y);
  String name();
}

public class BlankMap implements Map {
  private PImage mImg;
  private String mName;

  public BlankMap(String imageFilename) {
    mImg = loadImage(imageFilename);
    mName = imageFilename.replace(".png", "");
  }

  public void draw(float _x, float _y) {
    image(mImg, _x, _y);
  }

  public String name() {
    return mName;
  }

  public void addPoints(Points _mPoints) {
    _mPoints.clear();
  }
}

public class CidadeMap implements Map {
  private PImage mImg;
  private String mName;

  public CidadeMap(String imageFilename) {
    mImg = loadImage(imageFilename);
    mName = imageFilename.replace(".png", "");
  }

  public void draw(float _x, float _y) {
    image(mImg, _x, _y);
  }

  public String name() {
    return mName;
  }

  public void addPoints(Points _mPoints) {
    _mPoints.clear();
    _mPoints.add(new PVector(425, 32));
    _mPoints.add(new PVector(598, 190));
    _mPoints.add(new PVector(500, 242));
    _mPoints.add(new PVector(625, 267));
    _mPoints.add(new PVector(552, 467));
    _mPoints.add(new PVector(432, 458));
    _mPoints.add(new PVector(226, 377));
    _mPoints.add(new PVector(85, 273));
    _mPoints.add(new PVector(42, 549));
    _mPoints.add(new PVector(245, 645));
  }
}

public class LindaMap implements Map {
  private PImage mImg;
  private String mName;

  public LindaMap(String imageFilename) {
    mImg = loadImage(imageFilename);
    mName = imageFilename.replace(".png", "");
  }

  public void draw(float _x, float _y) {
    image(mImg, _x, _y);
  }

  public String name() {
    return mName;
  }

  public void addPoints(Points _mPoints) {
    _mPoints.clear();
    _mPoints.add(new PVector(219, 190));
    _mPoints.add(new PVector(357, 185));
    _mPoints.add(new PVector(488, 188));
    _mPoints.add(new PVector(465, 233));
    _mPoints.add(new PVector(678, 259));
    _mPoints.add(new PVector(184, 481));
    _mPoints.add(new PVector(195, 439));
    _mPoints.add(new PVector(352, 382));
    _mPoints.add(new PVector(566, 429));
    _mPoints.add(new PVector(589, 384));
    _mPoints.add(new PVector(437, 436));
    _mPoints.add(new PVector(195, 662));
  }
}

public class QueerMap implements Map {
  private PImage mImg;
  private String mName;

  public QueerMap(String imageFilename) {
    mImg = loadImage(imageFilename);
    mName = imageFilename.replace(".png", "");
  }

  public void draw(float _x, float _y) {
    image(mImg, _x, _y);
  }

  public String name() {
    return mName;
  }

  public void addPoints(Points _mPoints) {
    _mPoints.clear();
    _mPoints.add(new PVector(550, 423));
    _mPoints.add(new PVector(704, 145));
    _mPoints.add(new PVector(881, 520));
    _mPoints.add(new PVector(650, 589));
    _mPoints.add(new PVector(632, 312));
    _mPoints.add(new PVector(710, 474));
    _mPoints.add(new PVector(598, 340));
    _mPoints.add(new PVector(435, 392));
    _mPoints.add(new PVector(386, 604));
    _mPoints.add(new PVector(884, 400));
    _mPoints.add(new PVector(1015, 329));
    _mPoints.add(new PVector(438, 390));
    _mPoints.add(new PVector(537, 350));
    _mPoints.add(new PVector(572, 284));
    _mPoints.add(new PVector(617, 283));
    _mPoints.add(new PVector(632, 250));
    _mPoints.add(new PVector(650, 589));
    _mPoints.add(new PVector(632, 250));
    _mPoints.add(new PVector(396, 129));
    _mPoints.add(new PVector(609, 517));
    _mPoints.add(new PVector(749, 254));
    _mPoints.add(new PVector(657, 299));
    _mPoints.add(new PVector(759, 267));
    _mPoints.add(new PVector(398, 607));
    _mPoints.add(new PVector(493, 183));
    _mPoints.add(new PVector(406, 182));
    _mPoints.add(new PVector(498, 373));
    _mPoints.add(new PVector(590, 455));
    _mPoints.add(new PVector(907, 425));
    _mPoints.add(new PVector(906, 117));
    _mPoints.add(new PVector(479, 416));
    _mPoints.add(new PVector(380, 596));
    _mPoints.add(new PVector(1015, 258));
    _mPoints.add(new PVector(369, 210));
    _mPoints.add(new PVector(446, 413));
    _mPoints.add(new PVector(615, 429));
    _mPoints.add(new PVector(934, 362));
    _mPoints.add(new PVector(873, 352));
    _mPoints.add(new PVector(596, 179));
    _mPoints.add(new PVector(453, 417));
    _mPoints.add(new PVector(510, 274));
    _mPoints.add(new PVector(411, 544));
    _mPoints.add(new PVector(396, 129));
    _mPoints.add(new PVector(535, 350));
    _mPoints.add(new PVector(368, 388));
    _mPoints.add(new PVector(499, 430));
    _mPoints.add(new PVector(575, 295));
    _mPoints.add(new PVector(534, 336));
    _mPoints.add(new PVector(970, 349));
    _mPoints.add(new PVector(532, 81));
    _mPoints.add(new PVector(697, 482));
    _mPoints.add(new PVector(396, 129));
    _mPoints.add(new PVector(632, 250));
    _mPoints.add(new PVector(453, 415));
    _mPoints.add(new PVector(487, 374));
    _mPoints.add(new PVector(704, 144));
    _mPoints.add(new PVector(652, 287));
    _mPoints.add(new PVector(538, 416));
    _mPoints.add(new PVector(451, 151));
    _mPoints.add(new PVector(305, 253));
    _mPoints.add(new PVector(581, 429));
    _mPoints.add(new PVector(783, 227));
  }
}