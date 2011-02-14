//
//  Mod1AUGraph.h
//  Mod-1
//
//  Created by Schell Scivally on 1/29/11.
//  Copyright 2011 Electrunique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioUnit/AudioUnit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "HeadUnit.h"
#import "GainUnit.h"
#import "NoiseGeneratorUnit.h"

@interface Mod1Graph : NSObject {
	AUGraph _graph;
	AUNode _outputNode;
	AudioStreamBasicDescription _dataFormat;
	NoiseGeneratorUnit* _noiseUnit;
	GainUnit* _gainUnit;
	HeadUnit* headUnit;
}
- (BOOL)play:(NSError**)error;
- (BOOL)stop:(NSError**)error;
@property (readonly) HeadUnit* headUnit;
@end
