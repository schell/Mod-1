//
//  GainUnit.m
//  Mod-1
//
//  Created by Schell Scivally on 2/6/11.
//  Copyright 2011 Electrunique. All rights reserved.
//

#import "GainUnit.h"
#import "ModularInput.h"
#import "ModularOutput.h"

@implementation GainUnit
@synthesize defaultGain;

#pragma mark -
#pragma mark Lifecycle

- (id)init {
	self = [super init];
	self.defaultGain = 0.5;
	return self;
}

#pragma mark -
#pragma mark Connections

- (BOOL)initializeConnections {
	NSLog(@"%s",__FUNCTION__);
	[super initializeConnections];
	return YES;
}

- (NSArray*)connections {
	return [NSArray arrayWithObjects:[self input],[self output],nil];
}

#pragma mark -
#pragma mark Details

- (NSString*)description {
	return @"GainUnit";
}

#pragma mark -
#pragma mark Render

- (BOOL)fillBuffer:(SampleBuffer*)buffer {
	// default behaviour is to passthrough if input available, else render silence...
	if ([self input].remoteUnit != nil) {
		[[self input].remoteUnit fillBuffer:buffer];
		for (UInt32 i = 0; i < buffer.numberOfFrames; i++) {
			buffer.leftChannel[i] *= self.defaultGain;
			if (buffer.isStereo) {
				buffer.rightChannel[i] *= self.defaultGain;
			}
		}
	} else {
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