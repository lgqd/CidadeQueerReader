#include "Quadrant.h"

Quadrant::Quadrant() {}

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

bool Quadrant::has(const ofVec2f& point) {
    return (point.x >= offset.x) && (point.y >= offset.y) && (point.x <= (offset.x + range.x)) && (point.y <= (offset.y + range.y));
}

void Quadrant::setCorners(std::vector<ofVec2f>& _corners) {
    for(int i=0; i<_corners.size() && i<4; ++i) {
        corners.at(i).set(_corners.at(i));
        normalizedCorners.at(i).set(normalizeCorner(_corners.at(i)));
    }
    calculateWarpParameters();
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
