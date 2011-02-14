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

@implementation SineWaveGeneratorUnit
@synthesize frequency,amplitude,phaseDifference;

- (id)init {
	NSLog(@"%s",__FUNCTION__);
	self = [super init];
	phase = 0.0;
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
	self.phaseDifference = [[ModularConnection alloc] initWithType:ModularConnectionTypeInput andName:@"phase difference"];
	return YES;
}

- (NSArray*)connections {
	return [NSArray arrayWithObjects:self.output,self.frequency,self.amplitude,self.phaseDifference,nil];
}

#pragma mark -
#pragma mark Rendering

- (BOOL)fillBuffer:(SampleBuffer*)buffer {
	float phaseInc = 2.0 * M_PI * DEFAULT_FREQ/44100.0;
	for (UInt32 i = 0; i < buffer.numberOfFrames; i++) {
		buffer.leftChannel[i] = (AudioUnitSampleType) (sin(phase)*(CGFloat)0x00FFFFFF);
		if (buffer.isStereo) {
			buffer.rightChannel[i] = (AudioUnitSampleType) (sin(phase)*(CGFloat)0x00FFFFFF);
		}
		phase = fmod(phase + phaseInc, 2.0 * M_PI);
	}
	
	return YES;
}

@end
