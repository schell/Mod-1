//
//  ModularUnit.m
//  Mod-1
//
//  Created by Schell Scivally on 2/5/11.
//  Copyright 2011 Electrunique. All rights reserved.
//

#import <AudioUnit/AudioUnit.h>
#import "ModularUnit.h"
#import "ModularConnection.h"
#import "CommonAudioOps.h"

@implementation ModularUnit
@synthesize input,output;

#pragma mark -
#pragma mark Lifecycle

- (id)init {
	NSLog(@"%s",__FUNCTION__);
	self = [super init];
	// setup input and output
	if (![self initializeConnections]) {
		[NSException raise:@"could not initialize connections" format:@"unknown error"];
	}
	return self;
}

- (void)dealloc {
	self.input = nil;
	self.output = nil;
	[super dealloc];
}

#pragma mark -
#pragma mark Data Format

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
#pragma mark Rendering

- (BOOL)fillBuffer:(SampleBuffer*)buffer {
	// default behaviour is to passthrough if input available, else render silence...

	if (self.input.inputUnit != nil) {
		// pass through
		[self.input.inputUnit fillBuffer:buffer];
	} else {
		// silence
		for (UInt32 i = 0; i < buffer.numberOfFrames; i++) {
			buffer.leftChannel[i] = 0;
			if (buffer.isStereo) {
				buffer.rightChannel[i] = 0;
			}
		}
	}
	return YES;
}
@end
