#pragma once

#include "ofMath.h"
#include "Quadrant.h"

class Grid {
    public:
        Grid();
        void warp();
    private:
        void addQuadrant(Quadrant& _quad);
        std::vector<Quadrant> quads;
};
