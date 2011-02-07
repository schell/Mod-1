//
//  Mod1AUGraph.m
//  Mod-1
//
//  Created by Schell Scivally on 1/29/11.
//  Copyright 2011 Electrunique. All rights reserved.
//

#import "Mod1AUGraph.h"
#import "ModularConnection.h"
#import "NoiseGeneratorUnit.h"
#import "GainUnit.h"
#import "CommonAudioOps.h"

#define FAIL_ON_ERR(_X_) if ((status = (_X_)) != noErr) { goto failed; }

@interface Mod1AUGraph (PrivateMethods)
- (OSStatus)addOutputNode;
- (OSStatus)addConverterNode;
- (OSStatus)setDataFormatOfConverterAudioUnit;
- (OSStatus)setMaximumFramesPerSlice;
- (OSStatus)setRenderCallbackOfConverterNode;
- (void)setupDataFormat;
@end

static OSStatus render(void*						inRefCon,
						   AudioUnitRenderActionFlags*	ioActionFlags,
						   const AudioTimeStamp*		inTimeStamp,
						   UInt32						inBusNumber,
						   UInt32						inNumberFrames,
						   AudioBufferList*				ioData);

@implementation Mod1AUGraph
@synthesize headUnit;

#pragma mark -
#pragma mark Lifecycle

- (id)init {
	NSLog(@"%s",__FUNCTION__);
	self = [super init];
	
	headUnit = [[HeadUnit alloc] init];
	_gainUnit = [[GainUnit alloc] init];
	_noiseUnit = [[NoiseGeneratorUnit alloc] init];
	headUnit.input.inputUnit = _gainUnit;
	_gainUnit.input.inputUnit = _noiseUnit;
	
	[self setupDataFormat];
	
	return self;
}

#pragma mark -
#pragma mark Play/Stop

- (BOOL)play:(NSError**)error {
	NSLog(@"%s",__FUNCTION__);
	NSAssert(_graph == NULL, @"AUGraph is already started");
	
	OSStatus status;
	
	FAIL_ON_ERR(NewAUGraph(&_graph));
	FAIL_ON_ERR([self addOutputNode]);
	FAIL_ON_ERR([self addConverterNode]);
	FAIL_ON_ERR(AUGraphConnectNodeInput(_graph, _converterNode, 0, _outputNode, 0));
	FAIL_ON_ERR(AUGraphOpen(_graph));
	FAIL_ON_ERR([self setDataFormatOfConverterAudioUnit]);
	FAIL_ON_ERR([self setMaximumFramesPerSlice]);
	FAIL_ON_ERR([self setRenderCallbackOfConverterNode]);
	FAIL_ON_ERR(AUGraphInitialize(_graph));
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
	NSLog(@"%s",__FUNCTION__);
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
	AudioComponentDescription description = {0};
	description.componentType = kAudioUnitType_Output;
	description.componentSubType = kAudioUnitSubType_RemoteIO;
	description.componentManufacturer = kAudioUnitManufacturer_Apple;
	return AUGraphAddNode(_graph, &description, &_outputNode);
}

- (OSStatus)addConverterNode {
	AudioComponentDescription description = {0};
	description.componentType = kAudioUnitType_FormatConverter;
	description.componentSubType = kAudioUnitSubType_AUConverter;
	description.componentManufacturer = kAudioUnitManufacturer_Apple;
	return AUGraphAddNode(_graph, &description, &_converterNode);
}

- (void)setupDataFormat {
	_dataFormat = DefaultAudioStreamBasicDescription();
}

- (OSStatus)setDataFormatOfConverterAudioUnit {
	AudioUnit converterAudioUnit;
	OSStatus status;
	status = AUGraphNodeInfo(_graph, _converterNode, NULL, &converterAudioUnit);
	if (status != noErr) {
		return status;
	}
	status = AudioUnitSetProperty(converterAudioUnit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Input, 0, &_dataFormat, sizeof(_dataFormat));
	return status;
}

- (OSStatus)setMaximumFramesPerSlice {
	/*
     * See Technical Q&A QA1606 Audio Unit Processing Graph -
     *   Ensuring audio playback continues when screen is locked
     *
     * http://developer.apple.com/iphone/library/qa/qa2009/qa1606.html
     *
     * Need to set kAudioUnitProperty_MaximumFramesPerSlice to 4096 on all
     * non-output audio units.  In this case, that's only the converter unit.
     */
	AudioUnit audioUnit;
	OSStatus status;
	status = AUGraphNodeInfo(_graph, _converterNode, NULL, &audioUnit);
	if (status != noErr) {
		return status;
	}
	AudioUnitSetProperty(audioUnit, kAudioUnitProperty_MaximumFramesPerSlice, kAudioUnitScope_Global, 0, &(UInt32){4096}, sizeof(UInt32));
	return status;
}

- (OSStatus)setRenderCallbackOfConverterNode {
	AURenderCallbackStruct callback = {0};
	callback.inputProc = render;
	callback.inputProcRefCon = self;
	return AUGraphSetNodeInputCallback(_graph, _converterNode, 0, &callback);
}

#pragma mark -
#pragma mark Rendering

static OSStatus render(void*						inRefCon,
					   AudioUnitRenderActionFlags*	ioActionFlags,
					   const AudioTimeStamp*		inTimeStamp,
					   UInt32						inBusNumber,
					   UInt32						inNumberFrames,
					   AudioBufferList*				ioData) {
	NSAutoreleasePool* threadPool = [[NSAutoreleasePool alloc] init];
	Mod1AUGraph* self = inRefCon;
	
	[self->headUnit output:inNumberFrames intoBufferList:ioData]; 

	[threadPool drain];
	return noErr;
}

- (GainUnit*)gainUnit {
	return _gainUnit;
}

@end