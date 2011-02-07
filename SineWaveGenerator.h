//
//  SineWaveGenerator.h
//  Mod-1
//
//  Created by Schell Scivally on 1/30/11.
//  Copyright 2011 Electrunique. All rights reserved.
//

#include <stdint.h>

typedef struct {
	float currentPhase;
	float phaseIncrement;
} SineWaveGenerator;

void SineWaveGeneratorInitWithFrequency(SineWaveGenerator* generator, double frequency);
int16_t SineWaveGeneratorNextSample(SineWaveGenerator* generator);
void SineWaveGeneratorSetFrequency(SineWaveGenerator* generator, double frequency);
