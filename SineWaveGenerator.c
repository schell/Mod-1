//
//  SineWaveGenerator.m
//  Mod-1
//
//  Created by Schell Scivally on 1/30/11.
//  Copyright 2011 Electrunique. All rights reserved.
//
#import <AudioToolbox/AudioToolbox.h>
#include <math.h>
#include "SineWaveGenerator.h"

void SineWaveGeneratorInitWithFrequency(SineWaveGenerator* self, double frequency) {
    // Given:
    //   frequency in cycles per second
    //   2*PI radians per sine wave cycle
    //   sample rate in samples per second
    //
    // Then:
    //   cycles     radians     seconds     radians
    //   ------  *  -------  *  -------  =  -------
    //   second      cycle      sample      sample
    self->currentPhase = 0.0;
    SineWaveGeneratorSetFrequency(self, frequency);
}

int16_t SineWaveGeneratorNextSample(SineWaveGenerator* self) {
    int16_t sample = INT16_MAX * sinf(self->currentPhase);
    
    self->currentPhase += self->phaseIncrement;
    // Keep the value between 0 and 2*M_PI
    while (self->currentPhase > 2*M_PI) {
        self->currentPhase -= 2*M_PI;
    }
    
    return sample;
}

void SineWaveGeneratorSetFrequency(SineWaveGenerator* self, double frequency) {
	self->phaseIncrement = frequency * 2*M_PI / 44100.0;
}