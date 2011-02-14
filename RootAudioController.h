//
//  RootAudioController.h
//  Mod-1
//
//  Created by Schell Scivally on 1/25/11.
//  Copyright 2011 Electrunique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "Mod1Graph.h"

@interface RootAudioController : NSObject <AVAudioSessionDelegate> {
	AVAudioSession* _session;
	Mod1Graph* _graph;
}
- (AVAudioSession*)audioSession;
- (void)setupAudioSession;
- (void)activateAudioSession;
- (Mod1Graph*)mainGraph;
- (void)startGraph;
- (void)stopGraph;
@end
