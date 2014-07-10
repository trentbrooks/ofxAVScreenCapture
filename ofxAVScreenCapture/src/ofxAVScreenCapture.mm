#include "ofxAVScreenCapture.h"
#include "AVScreenCapture.h"
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


//--------------------------------------------------------------
ofxAVScreenCapture::ofxAVScreenCapture(){
    bRecording = bRecordInitialised = false;
    outputPath = "capture.mov";
    fps = 60;
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

void ofxAVScreenCapture::stopRecording() {
    
    bRecording = false;
}


//--------------------------------------------------------------
void ofxAVScreenCapture::threadedFunction() {
    while( isThreadRunning() ){
    
        if(bRecording) {
            
            if(!bRecordInitialised) {
                
                ofLog() << "Beginning AVF recording";
                bRecordInitialised = true;
                recorder = [[AVScreenCapture alloc] init];
                string localPath = ofToDataPath(outputPath);
                NSString *path = [[NSString alloc] initWithString:[NSString stringWithUTF8String:localPath.c_str()]];
                path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL *dest = [[NSURL alloc] init];
                dest = [NSURL fileURLWithPath:path];
                                
                // retina fix (only works for glfw) - dividing window coords by pixel scale
                ofAppGLFWWindow* glWindow = (ofAppGLFWWindow*)ofGetWindowPtr();
                int pixelsScale = glWindow->getPixelScreenCoordScale();
                CGRect rect = CGRectMake(ofGetWindowPositionX()/pixelsScale, ofGetWindowPositionY()/pixelsScale, ofGetWindowWidth()/pixelsScale, ofGetWindowHeight()/pixelsScale);
                
                //[(AVScreenCapture *)recorder screenRecording:dest];
                [(AVScreenCapture *)recorder startRecording:dest withRect:rect withFps:fps];
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

