#pragma once

#include "ofMain.h"
#include "Quadrant.h"

class ofApp : public ofBaseApp{
	public:
		void setup();
		void update();
		void draw();

		void keyReleased(int key);
		void mouseDragged(int x, int y, int button);
		void mousePressed(int x, int y, int button);
		void mouseReleased(int x, int y, int button);
    private:
        ofTrueTypeFont mFont;
        Quadrant mQuad;
        vector<ofPolyline> originalPolylines;
        vector<ofPolyline> warpedPolylines;
    
};
