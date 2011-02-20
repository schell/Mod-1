//
//  Mod1AUGraph.m
//  Mod-1
//
//  Created by Schell Scivally on 1/29/11.
//  Copyright 2011 Electrunique. All rights reserved.
//

#import "Mod1Graph.h"
#import "ModularConnection.h"
#import "NoiseGeneratorUnit.h"
#import "GainUnit.h"
#import "CommonAudioOps.h"
#import "SampleBuffer.h"
#import "SineWaveGeneratorUnit.h"
#import "SquareWaveGeneratorUnit.h"

#define FAIL_ON_ERR(_X_) if ((status = (_X_)) != noErr) { goto failed; }
#define SCALE_UNIT_2_IO(_sample_) (AudioSampleType)((_sample_/512) & 0x00FFFFFF)
//__inline AudioSampleType scale_unit2io(AudioUnitSampleType sample) {
//	AudioUnitSampleType fraction = sample/512;
//	return (AudioSampleType)(fraction & 0x00FFFFFF);
//}

@interface Mod1Graph (PrivateMethods)
- (OSStatus)addOutputNode;
- (OSStatus)addConverterNode;
- (OSStatus)setDataFormatOfConverterAudioUnit;
- (OSStatus)setDataFormatOfOutputAudioUnit;
- (OSStatus)setMaximumFramesPerSlice;
- (OSStatus)setRenderCallbackOfConverterNode;
- (OSStatus)setRenderCallbackOfOutputNode;
- (void)setupDataFormat;
@end

static OSStatus render(void*						inRefCon,
						   AudioUnitRenderActionFlags*	ioActionFlags,
						   const AudioTimeStamp*		inTimeStamp,
						   UInt32						inBusNumber,
						   UInt32						inNumberFrames,
						   AudioBufferList*				ioData);

@implementation Mod1Graph
@synthesize headUnit;

#pragma mark -
#pragma mark Lifecycle

- (id)init {
	NSLog(@"%s",__FUNCTION__);
	self = [super init];
	
	headUnit = [[HeadUnit alloc] init];
	
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
	FAIL_ON_ERR(AUGraphOpen(_graph));
	FAIL_ON_ERR([self setDataFormatOfOutputAudioUnit]);
	FAIL_ON_ERR([self setRenderCallbackOfOutputNode]);
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

- (void)setupDataFormat {
	UInt32 formatFlags = 0 | kAudioFormatFlagsAudioUnitCanonical;
	AudioStreamBasicDescription dataFormat = (AudioStreamBasicDescription) {0};
	dataFormat.mFormatID = kAudioFormatLinearPCM;
	dataFormat.mFormatFlags = formatFlags;
	dataFormat.mSampleRate = 44100.0;
	dataFormat.mBitsPerChannel = 8 * sizeof(AudioUnitSampleType);
	dataFormat.mChannelsPerFrame = 2;
	dataFormat.mBytesPerFrame = sizeof(AudioUnitSampleType);
	dataFormat.mFramesPerPacket = 1;
	dataFormat.mBytesPerPacket = dataFormat.mBytesPerFrame;
	_dataFormat = dataFormat;
}

- (OSStatus)setDataFormatOfOutputAudioUnit {
	AudioUnit outputAudioUnit;
	OSStatus status;
	status = AUGraphNodeInfo(_graph, _outputNode, NULL, &outputAudioUnit);
	if (status != noErr) {
		return status;
	}
	status = AudioUnitSetProperty(outputAudioUnit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Input, 0, &_dataFormat, sizeof(_dataFormat));
	return status;
}

- (OSStatus)setRenderCallbackOfOutputNode {
	AURenderCallbackStruct callback = {0};
	callback.inputProc = render;
	callback.inputProcRefCon = self;
	return AUGraphSetNodeInputCallback(_graph, _outputNode, 0, &callback);
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
	Mod1Graph* self = inRefCon;
	SampleBuffer* sampleBuffer = [[SampleBuffer alloc] initWithNumberOfFrames:inNumberFrames inStereo:YES];
	HeadUnit* headUnit = self.headUnit;
	[headUnit fillBuffer:sampleBuffer];
	
	AudioUnitSampleType* left = ioData->mBuffers[0].mData;
	AudioUnitSampleType* right = ioData->mBuffers[1].mData;
	
	for (UInt32 i = 0; i < inNumberFrames; i++) {
		left[i] = sampleBuffer.leftChannel[i];
		right[i] = sampleBuffer.rightChannel[i];
	}
	
	[sampleBuffer release];
	[threadPool drain];
	return noErr;
}

- (GainUnit*)gainUnit {
	return _gainUnit;
}

@end