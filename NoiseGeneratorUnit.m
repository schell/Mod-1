//
//  NoiseGeneratorUnit.m
//  Mod-1
//
//  Created by Schell Scivally on 2/6/11.
//  Copyright 2011 Electrunique. All rights reserved.
//

#import <AudioUnit/AudioUnit.h>
#import "NoiseGeneratorUnit.h"
#import "CommonAudioOps.h"

@implementation NoiseGeneratorUnit

#pragma mark -
#pragma mark Connections

- (BOOL)initializeConnections {
	[super initializeConnections];
	input = nil;
	return YES;
}

- (NSArray*)connections {
	return [NSArray arrayWithObjects:output,nil];
}

#pragma mark -
#pragma mark Rendering

- (void)fillBufferUsingMethodOne:(SampleBuffer*)buffer {
	for (UInt32 i = 0; i < buffer.numberOfFrames; i++) {
		buffer.leftChannel[i] = (rand()%0x1FFFFFE) - 0x00FFFFFF;
		if (buffer.isStereo) {
			buffer.rightChannel[i] = (rand()%0x1FFFFFE) - 0x00FFFFFF;
		}	
	}
}

- (void)fillBufferUsingMethodTwo:(SampleBuffer *)buffer {
	const AudioUnitSampleType range = 0x1FFFFFE;
	const AudioUnitSampleType maxAmplitude = 0x00FFFFFF;
	const AudioUnitSampleType factor = (double)RAND_MAX/(double)range;
	
	for (UInt32 i = 0; i < buffer.numberOfFrames; i++) {
		buffer.leftChannel[i] = rand()/factor - maxAmplitude;
		if (buffer.isStereo) {
			buffer.rightChannel[i] = rand()/factor - maxAmplitude;
		}	
	}
}

static time_t timer = 0;
static bool mod = 0;
- (BOOL)fillBuffer:(SampleBuffer*)buffer {
	time_t newTime = time(NULL);
	if (newTime - timer > 1) {
		timer = newTime;
		mod = !mod;
	}
	if (mod) {
		[self fillBufferUsingMethodOne:buffer];
	} else {
		[self fillBufferUsingMethodTwo:buffer];
	}
	return YES;
}

#pragma mark -
#pragma mark Details

- (NSString*)description {
	return @"NoiseGeneratorUnit";
}

@end
