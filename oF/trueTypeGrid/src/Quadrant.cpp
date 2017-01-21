#include "Quadrant.h"
#include "ofGraphics.h"

Quadrant::Quadrant(const ofVec2f& _offset, const ofVec2f& _range) {
    dragging = -1;
    isRegisterred = false;
    setup(_offset, _range);
}

Quadrant::~Quadrant() {
    if(isRegisterred) {
        ofUnregisterMouseEvents(this, OF_EVENT_ORDER_BEFORE_APP);
        isRegisterred = false;
    }
}

void Quadrant::setup(const ofVec2f& _offset, const ofVec2f& _range) {
    offset.set(_offset);
    range.set(_range);

    /*  
        (0,0), (1,0), (0,1), (1,1)

        0 --- 1
        |     |
        2 --- 3
    */

    for (int i=0; i<4; i++) {
        corners.push_back(ofVec2f(_range.x * (i%2) + _offset.x, _range.y * (i/2) + _offset.y));
        normalizedCorners.push_back(ofVec2f((i%2), (i/2)));
    }
    calculateWarpParameters();
}

void Quadrant::draw() {
    if(!isRegisterred) {
        ofRegisterMouseEvents(this, OF_EVENT_ORDER_BEFORE_APP);
        isRegisterred = true;
    }

    ofSetColor(64);
    ofDrawLine(corners.at(0), corners.at(1));
    ofDrawLine(corners.at(0), corners.at(2));
    ofDrawLine(corners.at(3), corners.at(1));
    ofDrawLine(corners.at(3), corners.at(2));

    ofSetColor(200,100,100);
    for (int i=0; i<corners.size(); ++i) {
        ofDrawCircle(corners.at(i), 10);
    }
}

bool Quadrant::has(const ofVec2f& point) {
    return (point.x >= offset.x) && (point.y >= offset.y) && (point.x <= (offset.x + range.x)) && (point.y <= (offset.y + range.y));
}

ofVec2f Quadrant::normalizeCorner(ofVec2f& _corner) {
    return ofVec2f((_corner.x - offset.x) / range.x, (_corner.y - offset.y) / range.y);
}

void Quadrant::calculateWarpParameters() {
    warpParameters.clear();

    warpParameters.push_back(normalizedCorners.at(0).x - normalizedCorners.at(1).x - normalizedCorners.at(2).x + normalizedCorners.at(3).x);
    warpParameters.push_back(normalizedCorners.at(1).x - normalizedCorners.at(0).x);
    warpParameters.push_back(normalizedCorners.at(2).x - normalizedCorners.at(0).x);
    warpParameters.push_back(normalizedCorners.at(0).x);

    warpParameters.push_back(normalizedCorners.at(0).y - normalizedCorners.at(1).y - normalizedCorners.at(2).y + normalizedCorners.at(3).y);
    warpParameters.push_back(normalizedCorners.at(1).y - normalizedCorners.at(0).y);
    warpParameters.push_back(normalizedCorners.at(2).y - normalizedCorners.at(0).y);
    warpParameters.push_back(normalizedCorners.at(0).y);
}

ofVec2f Quadrant::warpPoint(const ofVec2f& _point) {
    if(!has(_point)) {
        return ofVec2f(_point);
    } else {
        ofVec2f normalizedPoint = (_point - offset) / range;

        float nX = normalizedPoint.x * normalizedPoint.y * warpParameters[0] +
                   normalizedPoint.x * warpParameters[1] +
                   normalizedPoint.y * warpParameters[2] +
                   warpParameters[3];

        float nY = normalizedPoint.x * normalizedPoint.y * warpParameters[4] +
                   normalizedPoint.x * warpParameters[5] +
                   normalizedPoint.y * warpParameters[6] +
                   warpParameters[7];

        return ofVec2f(ofVec2f(nX, nY) * range + offset);
    }
}

void Quadrant::mousePressed(ofMouseEventArgs & args) {
    for(int i=0; i<corners.size(); ++i) {
        if(corners.at(i).squareDistance(ofVec2f(args.x,args.y)) < 32.0f) {
            dragging = i;
        }
    }
}

void Quadrant::mouseDragged(ofMouseEventArgs & args) {
    if((dragging > -1) && (dragging < 4)) {
        corners.at(dragging).set(args.x,args.y);
        normalizedCorners.at(dragging).set(normalizeCorner(corners.at(dragging)));
    }
}

void Quadrant::mouseReleased(ofMouseEventArgs & args) {
    calculateWarpParameters();
    dragging = -1;
}

void Quadrant::mouseMoved(ofMouseEventArgs & args) {}
void Quadrant::mouseScrolled(ofMouseEventArgs & args) {}
void Quadrant::mouseEntered(ofMouseEventArgs & args) {}
void Quadrant::mouseExited(ofMouseEventArgs & args) {}
