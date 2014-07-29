#include "ofxAVScreenCapture.h"
#include "AVScreenCapture.h"
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


//--------------------------------------------------------------
ofxAVScreenCapture::ofxAVScreenCapture(){
    bRecording = bRecordInitialised = false;
    bRecordAudio = false;
    audioDeviceIndex = -1;
    outputPath = "capture.mov";
    fps = 60;
    
    recorder = [[AVScreenCapture alloc] init];
}

ofxAVScreenCapture::~ofxAVScreenCapture() {

	stopRecording();
    if(recorder) {
        ofLog() << "Releaseing recorder";
		[(AVScreenCapture *)recorder release];
    }
    
}

//--------------------------------------------------------------
void ofxAVScreenCapture::startRecording(string outputPath, int fps) {
    
    this->outputPath = outputPath;
    this->fps = fps;
    
    bRecording = true;
    startThread();
}

void ofxAVScreenCapture::startRecordingWithDefaultAudio(string outputPath, int fps) {
    
    bRecordAudio = true;
    startRecording(outputPath, fps);
}

void ofxAVScreenCapture::startRecordingWithAudioDevice(int deviceIndex, string outputPath, int fps) {
    
    bRecordAudio = true;
    audioDeviceIndex = deviceIndex;
    startRecording(outputPath, fps);
}

void ofxAVScreenCapture::stopRecording() {
    
    bRecording = false;
    bRecordAudio = false;
    audioDeviceIndex = -1;
}


//--------------------------------------------------------------
void ofxAVScreenCapture::listAudioDevices() {
    
    [(AVScreenCapture *)recorder listAudioDevices];
}

//--------------------------------------------------------------
void ofxAVScreenCapture::threadedFunction() {
    while( isThreadRunning() ){
    
        if(bRecording) {
            
            if(!bRecordInitialised) {
                
                ofLog() << "Beginning AVF recording";
                bRecordInitialised = true;
                //recorder = [[AVScreenCapture alloc] init];
                string localPath = ofToDataPath(outputPath);
                NSString *path = [[NSString alloc] initWithString:[NSString stringWithUTF8String:localPath.c_str()]];
                path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL *dest = [[NSURL alloc] init];
                dest = [NSURL fileURLWithPath:path];
                                
                // retina fix (only works for glfw) - dividing window coords by pixel scale
                //ofAppGLFWWindow* glWindow = (ofAppGLFWWindow*)ofGetWindowPtr();
                ofAppGLFWWindow* glWindow;
                glWindow = dynamic_cast<ofAppGLFWWindow*>(ofGetWindowPtr());
                int pixelsScale = glWindow->getPixelScreenCoordScale();
                CGRect rect = CGRectMake(ofGetWindowPositionX()/pixelsScale, ofGetWindowPositionY()/pixelsScale, ofGetWindowWidth()/pixelsScale, ofGetWindowHeight()/pixelsScale);
                
                //[(AVScreenCapture *)recorder screenRecording:dest];
                if(bRecordAudio) {
                    if(audioDeviceIndex >= 0)
                        [(AVScreenCapture *)recorder startRecordingWithAudioDeviceIndex:audioDeviceIndex forPath:dest withRect:rect andFps:fps];
                    else
                        [(AVScreenCapture *)recorder startRecordingWithDefaultAudio:dest withRect:rect andFps:fps];
                } else {
                    [(AVScreenCapture *)recorder startRecording:dest withRect:rect andFps:fps];
                }
                    
                
                [(AVScreenCapture *)recorder begin];
            }
        } else {
            
            if(bRecordInitialised) {
            
                ofLog() << "Stopping AVF recording";
                [(AVScreenCapture*)recorder stopRecording];
                bRecordInitialised = false;
                
                stopThread();
            }
            
        }
    }
}

