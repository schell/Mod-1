//
//  GainUnit.m
//  Mod-1
//
//  Created by Schell Scivally on 2/6/11.
//  Copyright 2011 Electrunique. All rights reserved.
//

#import "GainUnit.h"

@implementation GainUnit
@synthesize defaultGain;

#pragma mark -
#pragma mark Lifecycle

- (id)init {
	self = [super init];
	defaultGain = SAMPLE_MAX/2;
	return self;
}

#pragma mark -
#pragma mark Connections

- (BOOL)initializeConnections {
	NSLog(@"%s",__FUNCTION__);
	self.input = [[ModularConnection alloc] initWithType:ModularConnectionTypeInput andName:@"input"];
	self.input.outputUnit = self;
	self.output = [[ModularConnection alloc] initWithType:ModularConnectionTypeOutput andName:@"output"];
	self.output.inputUnit = self;
	return YES;
}

- (NSArray*)connections {
	return [NSArray arrayWithObjects:self.input,self.output,nil];
}

#pragma mark -
#pragma mark Render

- (BOOL)output:(NSUInteger)aNumberOfFrames intoBufferList:(AudioBufferList*)outputData {
	// default behaviour is to passthrough if input available, else render silence...
	SAMPLE_TYPE* outputSample = outputData->mBuffers[0].mData;
	UInt32 channelsPerFrame = self.dataFormat.mChannelsPerFrame;
	
	if (self.input.inputUnit != nil) {
		AudioBufferList* inputBuffer = AllocateABL(channelsPerFrame, self.dataFormat.mBytesPerFrame, true, aNumberOfFrames);
		SAMPLE_TYPE* inputSample = inputBuffer->mBuffers[0].mData;
		
		[self.input.inputUnit output:aNumberOfFrames intoBufferList:inputBuffer];
		
		for (UInt32 i = 0; i < aNumberOfFrames; i++) {
			outputSample[0] = inputSample[0] * defaultGain/SAMPLE_MAX;
			outputSample[1] = inputSample[1] * defaultGain/SAMPLE_MAX;
			outputSample += channelsPerFrame;
			inputSample += channelsPerFrame;
		}
		
		free(inputBuffer);
	} else {
		GenerateSilenceInBufferList(self.dataFormat, aNumberOfFrames, outputData);
	}
	
	outputData->mBuffers[0].mDataByteSize = aNumberOfFrames*self.dataFormat.mBytesPerFrame;
	
	return YES;
}


@end