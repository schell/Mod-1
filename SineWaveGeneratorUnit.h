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

@interface SineWaveGeneratorUnit : ModularUnit {
	CGFloat leftPhase;
	CGFloat rightPhase;
}
@property (readwrite,retain) ModularConnection* frequency;
@property (readwrite,retain) ModularConnection* amplitude;
@end
