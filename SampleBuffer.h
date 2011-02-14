//
//  SampleBuffer.h
//  Mod-1
//
//  Created by Schell Scivally on 2/12/11.
//  Copyright 2011 Electrunique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@interface SampleBuffer : NSObject {
	AudioUnitSampleType* leftChannel;
	AudioUnitSampleType* rightChannel;
	UInt32 numberOfFrames;
	BOOL isStereo;
}
- (id)initWithNumberOfFrames:(UInt32)frames inStereo:(BOOL)isInStereo;
@property (readonly) BOOL isStereo;
@property (readonly) AudioUnitSampleType* leftChannel;
@property (readonly) AudioUnitSampleType* rightChannel;
@property (readonly) UInt32 numberOfFrames;
@end
