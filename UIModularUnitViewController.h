//
//  UIModularUnitViewController.h
//  Mod-1
//
//  Created by Schell Scivally on 2/6/11.
//  Copyright 2011 Electrunique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModularUnit.h"

@interface UIModularUnitViewController : UIViewController {
	ModularUnit* unit;
	UIView* _topBar;
	UIView* _connectionsView;
	UIView* _backgroundView;
	UITableViewController* _inputsController;
	UITableViewController* _outputsController;
	NSMutableArray* _inputConnections;
	NSMutableArray* _outputConnections;
}
- (CGFloat)oneThirdPortraitWidth;
- (void)createView;
@property (readwrite,retain) ModularUnit* unit;
@end
