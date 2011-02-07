//
//  SineWaveGeneratorUnit.m
//  Mod-1
//
//  Created by Schell Scivally on 2/5/11.
//  Copyright 2011 Electrunique. All rights reserved.
//

#import <math.h>
#import "SineWaveGeneratorUnit.h"
#import "ModularConnection.h"
#import "CommonAudioOps.h"

#define DEFAULT_FREQ 440.0

@implementation SineWaveGeneratorUnit
@synthesize frequency,amplitude;

- (id)init {
	NSLog(@"%s",__FUNCTION__);
	self = [super init];
	leftPhase = 0.0;
	rightPhase = 0.0;
	return self;
}

#pragma mark -
#pragma mark Connections

- (BOOL)initializeConnections {
	NSLog(@"%s",__FUNCTION__);
	[super initializeConnections];
	self.input = nil;
	self.frequency = [[ModularConnection alloc] initWithType:ModularConnectionTypeInput andName:@"frequency"];
	self.amplitude = [[ModularConnection alloc] initWithType:ModularConnectionTypeInput andName:@"amplitude"];
	return YES;
}

- (NSArray*)connections {
	return [NSArray arrayWithObjects:self.output,self.frequency,self.amplitude,nil];
}

#pragma mark -
#pragma mark Rendering

- (BOOL)output:(NSUInteger)aNumberOfFrames intoBuffer:(AudioBufferList*)outputData {
	
	SAMPLE_TYPE* outputSample = outputData->mBuffers[0].mData;
	SAMPLE_TYPE left = 0.0f;
	SAMPLE_TYPE right = 0.0f;
	UInt32 channelsPerFrame = self.dataFormat.mChannelsPerFrame;
	
	AudioBufferList* freqBuffer;
	AudioBufferList* ampBuffer;
	BOOL hasFreqInput = self.frequency.inputUnit != nil;
	BOOL hasAmpInput = self.amplitude.inputUnit != nil;
	SAMPLE_TYPE* freqSample;
	SAMPLE_TYPE* ampSample;
	
	if (hasFreqInput) {
		freqBuffer = AllocateABL(channelsPerFrame, self.dataFormat.mBytesPerFrame, true, aNumberOfFrames);
		freqSample = freqBuffer->mBuffers[0].mData;
	}
	if (hasAmpInput) {
		ampBuffer = AllocateABL(channelsPerFrame, self.dataFormat.mBytesPerFrame, true, aNumberOfFrames);
		ampSample = ampBuffer->mBuffers[0].mData;
	}
	
	for (UInt32 i = 0; i < aNumberOfFrames; i++) {
		CGFloat phaseIncLeft,phaseIncRight;
		if (hasFreqInput) {
			phaseIncLeft = freqSample[0] * 2*M_PI / self.dataFormat.mSampleRate;
			phaseIncRight = freqSample[1] * 2*M_PI / self.dataFormat.mSampleRate;
			freqSample += channelsPerFrame;
		} else {
			phaseIncLeft = phaseIncRight = DEFAULT_FREQ * 2*M_PI / self.dataFormat.mSampleRate;
		}

		left = sinf(leftPhase);
		right = sinf(rightPhase);
		
		leftPhase += phaseIncLeft;
		rightPhase += phaseIncRight;
		// Keep the values between 0 and 2*M_PI
		while (leftPhase > 2*M_PI) {
			leftPhase -= 2*M_PI;
		}
		while (rightPhase > 2*M_PI) {
			rightPhase -= 2*M_PI;
		}
		
		if (hasAmpInput) {
			left *= ampSample[0];
			right *= ampSample[1];
			ampSample += channelsPerFrame;
		}
		outputSample[0] = left;
		outputSample[1] = right;
		outputSample += channelsPerFrame;
	}
	
	outputData->mBuffers[0].mDataByteSize = aNumberOfFrames*self.dataFormat.mBytesPerFrame;
	
	free(freqBuffer);
	free(ampBuffer);
	
	return YES;
}

@end
