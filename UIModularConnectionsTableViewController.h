//
//  UIModularConnectionsTableViewController.h
//  Mod-1
//
//  Created by Schell Scivally on 2/13/11.
//  Copyright 2011 Electrunique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModularUnit.h"

@interface UIModularConnectionsTableViewController : UITableViewController {}
- (void)createView;
@property (readwrite,retain) ModularUnit* unit;
@end
