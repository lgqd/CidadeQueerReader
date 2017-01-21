#include "Grid.h"

Grid::Grid() {}
Grid::~Grid() {}

void Grid::setup(ofVec2f _offset, ofVec2f _range, ofVec2f _numElements) {
    ofVec2f qRange = _range / _numElements;
    ofVec2f qOffset = ofVec2f(0,0);

    for(int i=0; i<_numElements.x; i++) {
        qOffset.x = _offset.x + i * qRange.x;
        for(int j=0; j<_numElements.y; j++) {
            qOffset.y = _offset.y + j * qRange.y;
            quads.push_back(Quadrant(qOffset, qRange));
        }
    }
}

void Grid::draw() {
    for(int i=0; i<quads.size(); ++i) {
        quads.at(i).draw();
    }
}

ofVec2f Grid::warpPoint(const ofVec2f& _point) {
    for(int i=0; i<quads.size(); ++i) {
        ofVec2f np = quads.at(i).warpPoint(_point);
        if (np.x != _point.x || np.y != _point.y) {
            return np;
        }
    }
    return _point;
}
