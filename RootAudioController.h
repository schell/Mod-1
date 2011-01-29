//
//  RootAudioController.h
//  Mod-1
//
//  Created by Schell Scivally on 1/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface RootAudioController : NSObject <AVAudioSessionDelegate> {
	AVAudioSession* _session;
}
- (AVAudioSession*)audioSession;
- (void)setupAudioSession;
- (void)activateAudioSession;
@end
