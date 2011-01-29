//
//  Mod1AUGraph.h
//  Mod-1
//
//  Created by Schell Scivally on 1/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioUnit/AudioUnit.h>
#import <AudioToolbox/AudioToolbox.h>

@interface Mod1AUGraph : NSObject {
	AUGraph _graph;
	AUNode _outputNode;
	AUNode _converterNode;
	AudioStreamBasicDescription _dataFormat;
}
- (BOOL)play:(NSError**)error;
- (BOOL)stop:(NSError**)error;
@end
