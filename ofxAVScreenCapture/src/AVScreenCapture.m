#include "AVScreenCapture.h"
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

// TODO: maybe remove windows rounded corner edges at the bottom- http://apple.stackexchange.com/questions/50280/how-can-i-disable-rounded-window-corners-in-os-x

//--------------------------------------------------------------
@implementation AVScreenCapture

-(void)startRecording:(NSURL *)destPath withRect:(CGRect)rect andFps:(int)fps {
//-(void)startRecording:(NSURL *)destPath withWidth:(int)width withHeight:(int)height withFps:(int)fps {
    //forScreenIndex:(uint32_t)screenIndex 
    
    // Create a capture session
    mSession = [[AVCaptureSession alloc] init];
    
    // Set the session preset as you wish
    mSession.sessionPreset = AVCaptureSessionPresetHigh;
    
    
    // If you're on a multi-display system and you want to capture a secondary display,
    // you can call CGGetActiveDisplayList() to get the list of all active displays.
    // For this example, we just specify the main display.
    CGDirectDisplayID displayId = kCGDirectMainDisplay; // get's the main display
    
    // gets the display with the point as defined by the rect origin
    CGDirectDisplayID theID;
    CGDisplayCount theCount;
    CGDisplayErr err = CGGetDisplaysWithPoint(rect.origin, 1, &theID, &theCount);
    if(err == kCGErrorSuccess) {
        displayId = theID;
    }

    
    // Create a ScreenInput with the display and add it to the session
    AVCaptureScreenInput *input = [[[AVCaptureScreenInput alloc] initWithDisplayID:displayId] autorelease];
    
    // set fps: https://developer.apple.com/library/mac/samplecode/AVScreenShack/Listings/AVScreenShack_AVScreenShackDocument_m.html
    CMTime minimumFrameDuration = CMTimeMake(1, (int32_t)fps);
    [input setMinFrameDuration:minimumFrameDuration];
    
    // crop rect: https://github.com/appium/screen_recording/blob/master/screen-recording/main.m
    // https://github.com/square/zapp/blob/master/Zapp/ZappVideoController.m
    CGRect displayBounds = CGDisplayBounds(displayId);
    //displayBounds.size.width = 2880;
    //displayBounds.size.height = 1800;
    NSLog(@"Dispaly bounds capture (x,y,w,h): %f %f %f %f", displayBounds.origin.x, displayBounds.origin.y, displayBounds.size.width, displayBounds.size.height);
    input.cropRect = CGRectMake(rect.origin.x - displayBounds.origin.x, displayBounds.size.height - displayBounds.origin.y - rect.origin.y - rect.size.height, rect.size.width, rect.size.height);
    input.removesDuplicateFrames = 0; // frame rate of export drops
    input.capturesCursor = 0;
    input.capturesMouseClicks = 0;
    //input.scaleFactor = 2.0;

    
    if (!input) {
        [mSession release];
        mSession = nil;
        return;
    }
    if ([mSession canAddInput:input])
        [mSession addInput:input];
    
    
    
    // Create a MovieFileOutput and add it to the session
    mMovieFileOutput = [[[AVCaptureMovieFileOutput alloc] init] autorelease];
    if ([mSession canAddOutput:mMovieFileOutput])
        [mSession addOutput:mMovieFileOutput];
    
    // Start running the session
    [mSession startRunning];
    
    // Delete any existing movie file first
    if ([[NSFileManager defaultManager] fileExistsAtPath:[destPath path]])
    {
        NSError *err;
        if (![[NSFileManager defaultManager] removeItemAtPath:[destPath path] error:&err])
        {
            NSLog(@"Error deleting existing movie %@",[err localizedDescription]);
        }
    }
    
    // Start recording to the destination movie file
    // The destination path is assumed to end with ".mov", for example, @"/users/master/desktop/capture.mov"
    // Set the recording delegate to self
    [mMovieFileOutput startRecordingToOutputFileURL:destPath recordingDelegate:self];
    
    NSLog(@"Started capture (x,y,w,h,fps): %f %f %f %f %d", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height, fps);

}


-(void)stopRecording {
    
    if([mMovieFileOutput isRecording]) {
        [mMovieFileOutput stopRecording];
        
        // must add this or it crashes on captureOutput delegate callback
        [mSession stopRunning];
        [mSession release];
        mSession = nil;
    }
    
    
}



// AVCaptureFileOutputRecordingDelegate methods
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    NSLog(@"File finished saving");
    //NSLog(@"Did finish recording to %@ due to error %@", [outputFileURL description], [error description]);
    
    // Stop running the session
    /*[mSession stopRunning];*/
    
    // Release the session
    //[mSession release];
    //mSession = nil;
    
}

@end
