//
//  SampleBuffer.m
//  Mod-1
//
//  Created by Schell Scivally on 2/12/11.
//  Copyright 2011 Electrunique. All rights reserved.
//

#import "SampleBuffer.h"

@implementation SampleBuffer
@synthesize isStereo,leftChannel,rightChannel,numberOfFrames;

#pragma mark -
#pragma mark Lifecycle

- (id)initWithNumberOfFrames:(UInt32)frames inStereo:(BOOL)isInStereo {
	self = [super init];
	
	numberOfFrames = frames;
	isStereo = isInStereo;
	
	leftChannel = (AudioUnitSampleType*) malloc(numberOfFrames*sizeof(AudioUnitSampleType));
	if (isStereo) {
		rightChannel = (AudioUnitSampleType*) malloc(numberOfFrames*sizeof(AudioUnitSampleType));
	}
	
	return self;
}

- (void)dealloc {
	free(leftChannel);
	free(rightChannel);
	[super dealloc];
}

@end
