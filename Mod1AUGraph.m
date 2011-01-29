//
//  Mod1AUGraph.m
//  Mod-1
//
//  Created by Schell Scivally on 1/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Mod1AUGraph.h"

#define FAIL_ON_ERR(_X_) if ((status = (_X_)) != noErr) { goto failed; }

@interface Mod1AUGraph (PrivateMethods)
- (OSStatus)addOutputNode;
- (OSStatus)addConverterNode;
- (OSStatus)setDataFormatOfConverterAudioUnit;
- (OSStatus)setMaximumFramesPerSlice;
- (OSStatus)setRenderCallbackOfConverterNode;
- (void)setupDataFormat;
@end

static OSStatus MyRenderer(void*						inRefCon,
						   AudioUnitRenderActionFlags*	ioActionFlags,
						   const AudioTimeStamp*		inTimeStamp,
						   UInt32						inBusNumber,
						   UInt32						inNumberFrames,
						   AudioBufferList*				ioData);
static void FillFrame(Mod1AUGraph* self, int16_t* sample);

@implementation Mod1AUGraph

#pragma mark -
#pragma mark Lifecycle

- (BOOL)play:(NSError**)error {
	NSAssert(_graph == NULL, @"AUGraph is already started");
	
	OSStatus status;
	
	FAIL_ON_ERR(NewAUGraph(&_graph));
	FAIL_ON_ERR([self addOutputNode]);
	FAIL_ON_ERR([self addConverterNode]);
	FAIL_ON_ERR(AUGraphConnectNodeInput(_graph, _converterNode, 0, _outputNode, 0));
	FAIL_ON_ERR(AUGraphOpen(_graph));
	[self setupDataFormat];
	FAIL_ON_ERR([self setDataFormatOfConverterAudioUnit]);
	FAIL_ON_ERR([self setMaximumFramesPerSlice]);
	FAIL_ON_ERR([self setRenderCallbackOfConverterNode]);
	//SineWaveGeneratorInitWithFrequency(&_sineWaveGenerator, 440.0);
	FAIL_ON_ERR(AUGraphStart(_graph));
	
	return YES;
	
failed:
	// Error handling...
    if (_graph != NULL) {
        DisposeAUGraph(_graph);
    }
    
    if (error != NULL) {
        *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil];
    }
    return NO;
}

- (BOOL)stop:(NSError **)error {
	NSAssert(_graph != NULL, @"AUGraph is not started");
	
	OSStatus status;
	
	FAIL_ON_ERR(AUGraphStop(_graph));
	FAIL_ON_ERR(AUGraphUninitialize(_graph));
	FAIL_ON_ERR(AUGraphClose(_graph));
	FAIL_ON_ERR(DisposeAUGraph(_graph));
	_graph = NULL;
	
	return YES;
	
failed:
	if (error != NULL) {
		*error = [NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil];
	}
	return NO;
}

#pragma mark -
#pragma mark Configuration

- (OSStatus)addOutputNode {
	
}

@end