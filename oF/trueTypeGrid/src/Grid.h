#pragma once

#include "ofMath.h"
#include "Quadrant.h"

class Grid {
    public:
        Grid();
        ~Grid();
        void setup(ofVec2f _offset, ofVec2f _range, ofVec2f _numElements);
        void draw();
        void warp();
    private:
        void addQuadrant(Quadrant& _quad);
        std::vector<Quadrant> quads;
};
