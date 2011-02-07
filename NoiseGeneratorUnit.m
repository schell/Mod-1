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
	NSLog(@"%s",__FUNCTION__);
	self.input = nil;
	self.output = [[ModularConnection alloc] initWithType:ModularConnectionTypeOutput andName:@"output"];
	self.output.inputUnit = self;
	return YES;
}

- (NSArray*)connections {
	return [NSArray arrayWithObjects:self.output,nil];
}

#pragma mark -
#pragma mark Rendering

- (BOOL)output:(NSUInteger)aNumberOfFrames intoBufferList:(AudioBufferList*)outputData {
	// default behaviour is to passthrough if input available, else render silence...
	SAMPLE_TYPE* sample = outputData->mBuffers[0].mData;
	UInt32 channelsPerFrame = self.dataFormat.mChannelsPerFrame;
	
	if (self.input.inputUnit != nil) {
		[self.input.inputUnit output:aNumberOfFrames intoBufferList:outputData];
	} else {
		srand(time(NULL)+clock());
		for (UInt32 i = 0; i < aNumberOfFrames; i++) {
			SAMPLE_TYPE rando = rand()%SAMPLE_MAX;
			//NSLog(@"%f",randf);
			sample[0] = rando;
			sample[1] = rando;
			sample += channelsPerFrame;
		}
	}
	
	outputData->mBuffers[0].mDataByteSize = aNumberOfFrames*self.dataFormat.mBytesPerFrame;
	
	return YES;
}
@end
