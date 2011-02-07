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
@synthesize dataFormat,input,output;

#pragma mark -
#pragma mark Lifecycle

- (id)init {
	NSLog(@"%s",__FUNCTION__);
	self = [super init];
	// setup default data format
	dataFormat = DefaultAudioStreamBasicDescription();
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

- (BOOL)output:(NSUInteger)aNumberOfFrames intoBufferList:(AudioBufferList*)outputData {
	// default behaviour is to passthrough if input available, else render silence...

	if (self.input.inputUnit != nil) {
		// pass through
		[self.input.inputUnit output:aNumberOfFrames intoBufferList:outputData];
	} else {
		// silence
		GenerateSilenceInBufferList(self.dataFormat, aNumberOfFrames, outputData);
	}
	
	outputData->mBuffers[0].mDataByteSize = aNumberOfFrames*self.dataFormat.mBytesPerFrame;
	
	return YES;
}
@end
