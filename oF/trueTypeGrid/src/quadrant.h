#pragma once

#include "ofMath.h"

class Quadrant {
    public:
        Quadrant();
        void setup(const ofVec2f& _offset, const ofVec2f& _range);
        void setCorners(std::vector<ofVec2f>& _corners);
        bool has(const ofVec2f& point);
        ofVec2f warpPoint(const ofVec2f& _point);
    private:
        ofVec2f offset;
        ofVec2f range;
        std::vector<ofVec2f> corners;
        std::vector<ofVec2f> normalizedCorners;
        std::vector<float> warpParameters;
        ofVec2f normalizeCorner(ofVec2f& _corner);
        void calculateWarpParameters();
};
