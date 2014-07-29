#pragma once

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface AVScreenCapture : NSObject <AVCaptureFileOutputRecordingDelegate> {
@private
    AVCaptureSession *mSession;
    AVCaptureMovieFileOutput *mMovieFileOutput;
    NSURL* mDestPath;
}


-(void)startRecording:(NSURL *)destPath withRect:(CGRect)rect andFps:(int)fps; // default - no audio
-(void)startRecordingWithDefaultAudio:(NSURL *)destPath withRect:(CGRect)rect andFps:(int)fps; // with default audio
-(void)startRecordingWithAudioDeviceIndex:(int)deviceIndex forPath:(NSURL *)destPath withRect:(CGRect)rect andFps:(int)fps; // with selected audio device index
-(void)startRecordingWithAudioDeviceID:(NSString *)uniqueID forPath:(NSURL *)destPath withRect:(CGRect)rect andFps:(int)fps; // with selected audio device uid
-(void)begin; // must call begin after startRecording
-(void)stopRecording;

-(void)listAudioDevices;

@end

