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

#import <Foundation/Foundation.h>
#include <AudioToolbox/AudioToolbox.h>

#pragma mark -
#pragma mark Working with samples

CGFloat scale_unit2float(AudioUnitSampleType sample);

#endif