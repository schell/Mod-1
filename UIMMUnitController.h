//
//  UIMMUnitController.h
//  Mod-1
//
//  Created by Schell Scivally on 2/6/11.
//  Copyright 2011 Electrunique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIMMViewController.h"
#import "ModularUnit.h"
#import "UIMMConnectionsController.h"

@interface UIMMUnitController : UIMMViewController {
	ModularUnit* unit;
	UIMMConnectionsController* _connectionsController;
}
@property (readwrite,retain) ModularUnit* unit;
@end
