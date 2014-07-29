#include "ofApp.h"


//--------------------------------------------------------------
void ofApp::setup(){
    
    ofSetFrameRate(60);
    
    // for capturing sound - we need to know which audio device to capture, default is microphone
    // if want to record the system audio (like this example), need to download SoundFlower http://cycling74.com/products/soundflower/ and set that as the input (same as how ScreenFlick works)
    // remember to switch the audio device in system prefs: http://apple.stackexchange.com/questions/50904/if-we-use-soundflower-to-record-the-systems-audio-output-then-we-cant-hear-it
    capture.listAudioDevices();
    
    sound.loadSound("1085.mp3");
    sound.play();
}

//--------------------------------------------------------------
void ofApp::update(){

    ofSetWindowTitle((capture.isRecording() ? "RECORDING" : "Not recording"));
    ofSoundUpdate();
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
            
            // record options
            //capture.startRecording("capture.mov", 60.0);
            //capture.startRecordingWithDefaultAudio("capture.mov", 60.0);
            capture.startRecordingWithAudioDevice(0, "capture.mov", 60.0); // SoundflowerEngine:0
            
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