//
//  ModularInput.h
//  Mod-1
//
//  Created by Schell Scivally on 2/20/11.
//  Copyright 2011 Electrunique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModularConnection.h"

@class ModularUnit;

@interface ModularInput : ModularConnection {
	ModularUnit* localUnit;
}
- (id)initWithLocalUnit:(ModularUnit*)unit andName:(NSString*)cName;
- (ModularUnit*)localUnit;
@property (readwrite,retain) ModularUnit* remoteUnit;
@end
