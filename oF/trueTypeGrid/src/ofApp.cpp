#include "ofApp.h"

void ofApp::setup() {
    ofBackground(200);
    mFont.load("arial.ttf", 600, true, true, true);

    drawGrid = true;
    mChar = 'U';

    mGrid.setup(ofVec2f(20,14), ofVec2f(600,650), ofVec2f(4,4));

    originalPolylines = mFont.getCharacterAsPoints(mChar).getOutline();
    warpedPolylines = mFont.getCharacterAsPoints(mChar).getOutline();
    for(int i=0; i<originalPolylines.size(); ++i) {
        for(int j=0; j<originalPolylines[i].size(); j++) {
            originalPolylines[i][j].y += 600;
            warpedPolylines[i][j].y += 600;
        }
    }
}

void ofApp::update() {}

void ofApp::draw() {
    ofSetColor(255);
    mFont.drawString(ofToString(mChar), 0,600);

    ofSetColor(200, 32, 32);
    ofBeginShape();
    for(int i=0; i<warpedPolylines.size(); ++i) {
        warpedPolylines[i].close();
        for(int j=0; j<warpedPolylines[i].getVertices().size(); j++) {
            ofVertex(warpedPolylines[i].getVertices().at(j).x, warpedPolylines[i].getVertices().at(j).y);
        }
    }
    ofEndShape();

    if(drawGrid) {
        mGrid.draw();
    }
}

void ofApp::mouseReleased(int x, int y, int button) {
    for(int i=0; i<originalPolylines.size(); ++i) {
        for(int j=0; j<originalPolylines[i].size(); j++) {
            warpedPolylines[i][j].set(mGrid.warpPoint(originalPolylines[i][j]));
        }
    }
}

void ofApp::keyReleased(int key) {
    if(key == ' ') {
        drawGrid = !drawGrid;
    }
}

void ofApp::mouseDragged(int x, int y, int button){}
void ofApp::mousePressed(int x, int y, int button){}
