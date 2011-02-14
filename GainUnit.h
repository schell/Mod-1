//
//  GainUnit.h
//  Mod-1
//
//  Created by Schell Scivally on 2/6/11.
//  Copyright 2011 Electrunique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModularUnit.h"
#import "ModularConnection.h"
#import "CommonAudioOps.h"

@interface GainUnit : ModularUnit {}
@property (readwrite) CGFloat defaultGain;
@end
