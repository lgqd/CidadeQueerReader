#pragma once

#include "ofMath.h"
#include "ofEvents.h"

class Quadrant {
    public:
        Quadrant();
        ~Quadrant();
        void setup(const ofVec2f& _offset, const ofVec2f& _range);
        bool has(const ofVec2f& point);
        ofVec2f warpPoint(const ofVec2f& _point);
        void draw();
        void mouseMoved(ofMouseEventArgs & args);
        void mouseDragged(ofMouseEventArgs & args);
        void mousePressed(ofMouseEventArgs & args);
        void mouseReleased(ofMouseEventArgs & args);
        void mouseScrolled(ofMouseEventArgs & args);
        void mouseEntered(ofMouseEventArgs & args);
        void mouseExited(ofMouseEventArgs & args);
    private:
        ofVec2f offset;
        ofVec2f range;
        int dragging;
        std::vector<ofVec2f> corners;
        std::vector<ofVec2f> normalizedCorners;
        std::vector<float> warpParameters;
        ofVec2f normalizeCorner(ofVec2f& _corner);
        void calculateWarpParameters();
};
