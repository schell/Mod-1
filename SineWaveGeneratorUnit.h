//
//  SineWaveGeneratorUnit.h
//  Mod-1
//
//  Created by Schell Scivally on 2/5/11.
//  Copyright 2011 Electrunique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModularUnit.h"
#import "SineWaveGenerator.h"

#define DEFAULT_FREQ 440.0

@interface SineWaveGeneratorUnit : ModularUnit {
	CGFloat phase;
	ModularInput* frequency;
	ModularInput* amplitude;
	ModularInput* phaseDifference;
}
@end
