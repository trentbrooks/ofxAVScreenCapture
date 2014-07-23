#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
    
    ofSetFrameRate(60);
    
}

//--------------------------------------------------------------
void ofApp::update(){

    ofSetWindowTitle((capture.isRecording() ? "RECORDING" : "Not recording"));
}

//--------------------------------------------------------------
float smoothSize = 0;
void ofApp::draw(){
    
    ofSetColor(0);
    ofDrawBitmapString("Press space to toggle screen record: " + ofToString(capture.isRecording()), 20, 20);
    ofDrawBitmapStringHighlight(ofToString(ofGetFrameRate()), 20, ofGetHeight()-20);
    
    ofColor c;
    c.setHsb(sin(ofGetElapsedTimef() / 5.0) * 255, 255, 255);
	ofSetColor(c);
    
    ofVec2f mouse = ofVec2f(ofGetMouseX(), ofGetMouseY());
    ofVec2f pMouse = ofVec2f(ofGetPreviousMouseX(), ofGetPreviousMouseY());
    float size = ofClamp((mouse - pMouse).length() * 5, 20, 500);
    smoothSize += (size - smoothSize) * .1;
    ofCircle(mouse.x, mouse.y, smoothSize);
    

}

//--------------------------------------------------------------
void ofApp::keyPressed(int key){

    if(key == ' ') {
        if(!capture.isRecording()) {
            capture.startRecording("capture.mov", 60.0);
        } else {
            capture.stopRecording();
            //capture.waitForThread();
        }
    }
}

//--------------------------------------------------------------
void ofApp::keyReleased(int key){

}

//--------------------------------------------------------------
void ofApp::mouseMoved(int x, int y){

}

//--------------------------------------------------------------
void ofApp::mouseDragged(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mousePressed(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mouseReleased(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::windowResized(int w, int h){

}

//--------------------------------------------------------------
void ofApp::gotMessage(ofMessage msg){

}

//--------------------------------------------------------------
void ofApp::dragEvent(ofDragInfo dragInfo){ 

}