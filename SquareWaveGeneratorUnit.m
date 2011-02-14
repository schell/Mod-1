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
	float phaseInc = 2.0 * M_PI * DEFAULT_FREQ/44100.0;
	for (UInt32 i = 0; i < buffer.numberOfFrames; i++) {
		buffer.leftChannel[i] = sin(phase) > 0.0 ? 0x00FFFFFF : 0xFF000000;
		if (buffer.isStereo) {
			buffer.rightChannel[i] = sin(phase) > 0.0 ? 0x00FFFFFF : 0xFF000000;
		}
		phase = fmod(phase + phaseInc, 2.0 * M_PI);
	}
	return YES;
}

@end
