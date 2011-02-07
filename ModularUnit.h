//
//  ModularUnit.h
//  Mod-1
//
//	The default mod unit. 
//	This unit is a pass-through. If no unit is set on its input connection's
//	inputUnit, it will generate silence.
//
//  Created by Schell Scivally on 2/5/11.
//  Copyright 2011 Electrunique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@class ModularConnection;

@interface ModularUnit : NSObject {
	AudioStreamBasicDescription dataFormat;
}
- (BOOL)initializeConnections;
- (BOOL)output:(NSUInteger)aNumberOfFrames intoBufferList:(AudioBufferList*)outputData;
- (NSArray*)connections;
@property (readwrite) AudioStreamBasicDescription dataFormat;
@property (readwrite,retain) ModularConnection* input;
@property (readwrite,retain) ModularConnection* output;
@end
