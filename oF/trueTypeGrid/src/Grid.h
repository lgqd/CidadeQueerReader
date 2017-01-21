#pragma once

#include "ofMath.h"
#include "Quadrant.h"

class Grid {
    public:
        Grid();
        ~Grid();
        void setup(ofVec2f _offset, ofVec2f _range, ofVec2f _numElements);
        void draw();
        ofVec2f warpPoint(const ofVec2f& _point);
    private:
        std::vector<Quadrant> quads;
};
