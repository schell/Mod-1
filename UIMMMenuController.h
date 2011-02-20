//
//  UIMMMenuController.h
//  Mod-1
//
//  Created by Schell Scivally on 2/14/11.
//  Copyright 2011 Electrunique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIMMViewController.h"
#import "UIMMUnitController.h"

@interface UIMMMenuController : UIMMViewController <UITableViewDelegate,UITableViewDataSource> {
	UITableView* _menuTableView;
}
@property (readwrite,copy) void (^unitSelectedBlock)(UIMMUnitController*);
@end