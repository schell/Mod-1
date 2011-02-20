//
//  ModularUnit.m
//  Mod-1
//
//  Created by Schell Scivally on 2/5/11.
//  Copyright 2011 Electrunique. All rights reserved.
//

#import <AudioUnit/AudioUnit.h>
#import "ModularUnit.h"
#import "CommonAudioOps.h"

@implementation ModularUnit

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
	input.remoteUnit = nil;
	output.remoteUnit = nil;
	[input release];
	[output release];
	[super dealloc];
}

#pragma mark -
#pragma mark Details

- (NSString*)description {
	return @"ModularUnit";
}

#pragma mark -
#pragma mark Connections

- (BOOL)initializeConnections {
	NSLog(@"%s",__FUNCTION__);
	input = [[ModularInput alloc] initWithLocalUnit:self andName:@"input"];
	output = [[ModularOutput alloc] initWithLocalUnit:self andName:@"output"];
	return YES;
}

- (ModularInput*)input {
	return input;
}

- (ModularOutput*)output {
	return output;
}

- (NSArray*)connections {
	return [NSArray arrayWithObjects:[self input],[self output],nil];
}

- (BOOL)disconnect:(ModularConnection *)connection {
	NSLog(@"%s",__FUNCTION__);
	ModularConnection* selectedConnection = nil;
	for (ModularConnection* possibleMatch in [self connections]) {
		if (possibleMatch == connection) {
			selectedConnection = possibleMatch;
			break;
		}
	}
	if (selectedConnection == nil) {
		// could not find connection
		return NO;
	}
	switch ([selectedConnection type]) {
		case ModularConnectionTypeInput: {
			[(ModularInput*)selectedConnection disconnect];
			assert(((ModularInput*)selectedConnection).remoteUnit == nil);
			break;
		}
		case ModularConnectionTypeOutput: {
			[(ModularOutput*)selectedConnection disconnect];
			assert(((ModularOutput*)selectedConnection).remoteUnit == nil);
			break;
		}
		default:
			return NO;
	}
	return YES;
}

#pragma mark -
#pragma mark Rendering

- (BOOL)fillBuffer:(SampleBuffer*)buffer {
	// default behaviour is to passthrough if input available, else render silence...

	if ([self input] != nil && [self input].remoteUnit != nil) {
		// pass through
		[[self input].remoteUnit fillBuffer:buffer];
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
