#pragma once

#include "ofMain.h"
#include "Quadrant.h"
#include "Grid.h"

class ofApp : public ofBaseApp{
	public:
		void setup();
		void update();
		void draw();
        void mouseReleased(int x, int y, int button);
		void keyReleased(int key);
        void mousePressed(int x, int y, int button);
		void mouseDragged(int x, int y, int button);
    private:
        ofTrueTypeFont mFont;
        Grid mGrid;
        vector<ofPolyline> originalPolylines;
        vector<ofPolyline> warpedPolylines;
};
