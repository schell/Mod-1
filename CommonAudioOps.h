/*
 *  CommonAudioOps.h
 *  Mod-1
 *
 *	A number of frequently used (Core)Audio operations.
 *
 *  Created by Schell Scivally on 2/5/11.
 *  Copyright 2011 Electrunique. All rights reserved.
 *
 */

#ifndef __COMMON_AUDIO_OPS__
#define __COMMON_AUDIO_OPS__

#include <AudioToolbox/AudioToolbox.h>

#define SAMPLE_TYPE int16_t
#define SAMPLE_MAX INT16_MAX

AudioBufferList* AllocateABL(UInt32 channelsPerFrame, UInt32 bytesPerFrame, bool interleaved, UInt32 capacityFrames);

AudioStreamBasicDescription DefaultAudioStreamBasicDescription();

void GenerateSilenceInBufferList(AudioStreamBasicDescription dataFormat, UInt32 aNumberOfFrames, AudioBufferList* outputData);

#endif