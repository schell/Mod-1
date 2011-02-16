//
//  UIMMMenuController.h
//  Mod-1
//
//  Created by Schell Scivally on 2/14/11.
//  Copyright 2011 Electrunique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIMMViewController.h"

@interface UIMMMenuController : UIMMViewController <UITableViewDelegate> {
	UITableView* _menuTableView;
}

@end