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
#import "SampleBuffer.h"

@class ModularConnection;

@interface ModularUnit : NSObject {}
- (BOOL)initializeConnections;
- (BOOL)fillBuffer:(SampleBuffer*)buffer;
- (NSArray*)connections;
@property (readwrite,retain) ModularConnection* input;
@property (readwrite,retain) ModularConnection* output;
@end
