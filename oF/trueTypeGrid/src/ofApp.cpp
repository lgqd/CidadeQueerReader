#include "ofApp.h"

void ofApp::setup() {
    ofBackground(200);
    mFont.load("arial.ttf", 600, true, true, true);
    mQuad.setup(ofVec2f(0,0), ofVec2f(600,600));

    vector<ofVec2f> newCorners;
    newCorners.push_back(ofVec2f(100,0));
    newCorners.push_back(ofVec2f(500,0));
    mQuad.setCorners(newCorners);

    originalPolylines = mFont.getCharacterAsPoints('Q').getOutline();
    for(int i=0; i<originalPolylines.size(); ++i) {
        for(int j=0; j<originalPolylines[i].size(); j++) {
            originalPolylines[i][j].y += 600;
            originalPolylines[i][j].set(mQuad.warpPoint(originalPolylines[i][j]));
        }
    }
}

void ofApp::update() {}

void ofApp::draw() {
    ofPushMatrix();
    ofTranslate(ofGetWidth()/4, 0);

    ofSetColor(255);
    mFont.drawString("Q", 0,600);

    ofSetColor(200, 32, 32);
    for(int i=0; i<originalPolylines.size(); ++i) {
        for(int j=0; j<originalPolylines[i].size(); j++) {
            ofDrawCircle(originalPolylines[i][j], 3);
        }
    }
    ofPopMatrix();
}

void ofApp::keyReleased(int key){}
void ofApp::mouseDragged(int x, int y, int button){}
void ofApp::mousePressed(int x, int y, int button){}
void ofApp::mouseReleased(int x, int y, int button){}
