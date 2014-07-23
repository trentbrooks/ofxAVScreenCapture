#pragma once
#include "ofMain.h"
#include "ofAppGLFWWindow.h"



class ofxAVScreenCapture : public ofThread {
public:
    
    ofxAVScreenCapture();
    ~ofxAVScreenCapture();
    
    void startRecording(string outputPath, int fps);
    void stopRecording();
    
    void threadedFunction();

    bool isRecording() {
        return bRecording;
    }

protected:
    
    void * recorder;
    string outputPath;
    int fps;
    
    bool bRecording, bRecordInitialised;
};

