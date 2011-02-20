//
//  SquareWaveGeneratorUnit.m
//  Mod-1
//
//  Created by Schell Scivally on 2/12/11.
//  Copyright 2011 Electrunique. All rights reserved.
//

#import "SquareWaveGeneratorUnit.h"
#import "SampleBuffer.h"

@implementation SquareWaveGeneratorUnit

- (BOOL)fillBuffer:(SampleBuffer *)buffer {
	[super fillBuffer:buffer];
	for (UInt32 i = 0; i < buffer.numberOfFrames; i++) {
		buffer.leftChannel[i] = buffer.leftChannel[i] > 0.0 ? 0x00FFFFFF : 0xFF000000;
		if (buffer.isStereo) {
			buffer.rightChannel[i] = buffer.rightChannel[i] > 0.0 ? 0x00FFFFFF : 0xFF000000;
		}
	}
	return YES;
}

#pragma mark -
#pragma mark Details

- (NSString*)description {
	return @"SquareWaveGeneratorUnit";
}

@end
