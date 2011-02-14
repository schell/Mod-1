/*
 *  CommonAudioOps.c
 *  Mod-1
 *
 *  Created by Schell Scivally on 2/5/11.
 *  Copyright 2011 Electrunique. All rights reserved.
 *
 */

#include "CommonAudioOps.h"

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

void GenerateSilenceInBufferList(AudioStreamBasicDescription dataFormat, UInt32 aNumberOfFrames, AudioBufferList* outputData) {
	SInt32* left = outputData->mBuffers[0].mData;
	SInt32* right = outputData->mBuffers[1].mData;
	UInt32 channelsPerFrame = dataFormat.mChannelsPerFrame; // should be one outputData.mNumBuffers should be 2
	
	// silence
	for (UInt32 i = 0; i < aNumberOfFrames; i++) {
		left[0] = 0;
		right[1] = 0;
		left += channelsPerFrame;
		right += channelsPerFrame;
	}
	
	outputData->mBuffers[0].mDataByteSize = outputData->mBuffers[1].mDataByteSize = aNumberOfFrames * dataFormat.mBytesPerFrame;
	
}

#pragma mark -
#pragma mark Working with samples

CGFloat scale_unit2float(AudioUnitSampleType sample) {
	AudioUnitSampleType whole = sample >> 24;
	AudioUnitSampleType max = (INT32_MAX & 0x00FFFFFF);
	CGFloat fraction = (CGFloat)(sample & 0x00FFFFFF)/max;
	return (CGFloat)whole+fraction;
}

#pragma mark -
#pragma mark Generators

