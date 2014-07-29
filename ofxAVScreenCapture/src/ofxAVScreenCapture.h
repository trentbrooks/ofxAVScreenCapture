#pragma once
#include "ofMain.h"
#include "ofAppGLFWWindow.h"


// if want to record the system audio, need to download SoundFlower http://cycling74.com/products/soundflower/ and set that as the input
// http://apple.stackexchange.com/questions/50904/if-we-use-soundflower-to-record-the-systems-audio-output-then-we-cant-hear-it

class ofxAVScreenCapture : public ofThread {
public:
    
    ofxAVScreenCapture();
    ~ofxAVScreenCapture();
    
    void startRecording(string outputPath, int fps);
    void startRecordingWithDefaultAudio(string outputPath, int fps);
    void startRecordingWithAudioDevice(int deviceIndex, string outputPath, int fps);
    void stopRecording();
    
    void listAudioDevices();
    
    void threadedFunction();

    bool isRecording() {
        return bRecording;
    }

protected:
    
    void * recorder;
    string outputPath;
    int fps;
    
    bool bRecording, bRecordInitialised;
    bool bRecordAudio;
    int audioDeviceIndex;
};

