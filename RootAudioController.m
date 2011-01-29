//
//  RootAudioController.m
//  Mod-1
//
//  Created by Schell Scivally on 1/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootAudioController.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation RootAudioController

#pragma mark -
#pragma mark LifeCycle

- (int)check1 {
	NSLog(@"%s",__FUNCTION__);
	return 0;
}

- (int)check2 {
	NSLog(@"%s",__FUNCTION__);
	return false;
}

- (int)check3 {
	NSLog(@"%s",__FUNCTION__);
	return NO;
}


- (id)init {
	self = [super init];
	_session = nil;
	[self setupAudioSession];
	//experiment
	NSLog(@"%s",__FUNCTION__);
	if ((BOOL)[self check1] ||
		(BOOL)[self check2] ||
		(BOOL)[self check3]) {
		NSLog(@"	errored!");
	} else {
		NSLog(@"	no error");
	}
	return self;
}

#pragma mark -
#pragma mark Audio Session

- (AVAudioSession*)audioSession {
	if (_session == nil) {
		_session = [AVAudioSession sharedInstance];
		NSError* error = nil;
		[_session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
		if (error != nil) {
			[NSException raise:@"could not set audio session category" format:@"%@",[error localizedFailureReason]];
		}
		OSStatus propertySetError = 0;
		UInt32 allowMixing = true;
		propertySetError = AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers,
												   sizeof(allowMixing),
												   &allowMixing);
		if (propertySetError) {
			[NSException raise:@"could not set audio session allow mixing property" format:@"for some reason"];
		}
	}
	return _session;
}

- (void)setupAudioSession {
	_session = [self audioSession];
	_session.delegate = self;
}

- (void)activateAudioSession {
	NSError* error = nil;
	if (![[self audioSession] setActive:YES error:&error]) {
		NSLog(@"%scould not activate audio session:%@",__FUNCTION__,[error localizedFailureReason]);
	}
}

#pragma mark -
#pragma mark AVAudioSessionDelegate

- (void)beginInterruption {
	NSLog(@"%s",__FUNCTION__);
}

- (void)endInterruption {
	NSLog(@"%s",__FUNCTION__);
	[self activateAudioSession];
}

@end
