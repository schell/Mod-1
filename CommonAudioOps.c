/*
 *  CommonAudioOps.c
 *  Mod-1
 *
 *  Created by Schell Scivally on 2/5/11.
 *  Copyright 2011 Electrunique. All rights reserved.
 *
 */

#include "CommonAudioOps.h"
#include <AudioToolbox/AudioToolbox.h>

AudioBufferList* AllocateABL(UInt32 channelsPerFrame, UInt32 bytesPerFrame, bool interleaved, UInt32 aNumberOfFrames)
{
    AudioBufferList* bufferList = NULL;
	
    UInt32 numBuffers = interleaved ? 1 : channelsPerFrame;
    UInt32 channelsPerBuffer = interleaved ? channelsPerFrame : 1;
	
    bufferList = (AudioBufferList*)(calloc(1, offsetof(AudioBufferList, mBuffers) + (sizeof(AudioBuffer) * numBuffers)));
	
    bufferList->mNumberBuffers = numBuffers;
	
    for(UInt32 bufferIndex = 0; bufferIndex < bufferList->mNumberBuffers; ++bufferIndex) {
        bufferList->mBuffers[bufferIndex].mData = (void*)(calloc(aNumberOfFrames, bytesPerFrame));
        bufferList->mBuffers[bufferIndex].mDataByteSize = aNumberOfFrames * bytesPerFrame;
        bufferList->mBuffers[bufferIndex].mNumberChannels = channelsPerBuffer;
    }
	
    return bufferList;
}

AudioStreamBasicDescription DefaultAudioStreamBasicDescription() {
	UInt32 formatFlags = (0 
						  | kAudioFormatFlagIsSignedInteger
						  | kAudioFormatFlagIsPacked
						  | kAudioFormatFlagsNativeEndian);
	AudioStreamBasicDescription dataFormat = (AudioStreamBasicDescription) {0};
	dataFormat.mFormatID = kAudioFormatLinearPCM;
	dataFormat.mFormatFlags = formatFlags;
	dataFormat.mSampleRate = 44100.0;
	dataFormat.mBitsPerChannel = 8 * sizeof(SAMPLE_TYPE);
	dataFormat.mChannelsPerFrame = 2;
	dataFormat.mBytesPerFrame = dataFormat.mChannelsPerFrame * sizeof(SAMPLE_TYPE);
	dataFormat.mFramesPerPacket = 1;
	dataFormat.mBytesPerPacket = dataFormat.mFramesPerPacket * dataFormat.mBytesPerFrame;
	return dataFormat;
}


void GenerateSilenceInBufferList(AudioStreamBasicDescription dataFormat, UInt32 aNumberOfFrames, AudioBufferList* outputData) {
	SAMPLE_TYPE* sample = outputData->mBuffers[0].mData;
	UInt32 channelsPerFrame = dataFormat.mChannelsPerFrame;
	
	// silence
	for (UInt32 i = 0; i < aNumberOfFrames; i++) {
		sample[0] = 0;
		sample[1] = 0;
		sample += channelsPerFrame;
	}
	
	outputData->mBuffers[0].mDataByteSize = aNumberOfFrames * dataFormat.mBytesPerFrame;
	
}