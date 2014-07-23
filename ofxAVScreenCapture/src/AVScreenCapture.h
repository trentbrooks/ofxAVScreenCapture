#pragma once

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface AVScreenCapture : NSObject <AVCaptureFileOutputRecordingDelegate> {
@private
    AVCaptureSession *mSession;
    AVCaptureMovieFileOutput *mMovieFileOutput;
}


-(void)startRecording:(NSURL *)destPath withRect:(CGRect)rect andFps:(int)fps; //forScreenIndex:(uint32_t)screenIndex 
-(void)stopRecording;

@end

