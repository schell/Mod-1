//
//  UIConnectionView.h
//  Mod-1
//
//  Created by Schell Scivally on 2/14/11.
//  Copyright 2011 Electrunique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UISocketView.h"
#import "ModularConnection.h"

@class UIMMConnectionsController;

@interface UIConnectionView : UIView {}
@property (readwrite,retain) UIMMConnectionsController* controller;
@property (readwrite,retain) UISocketView* socketView;
@property (readwrite,retain) UIConnectionView* wiredConnectionView;
@property (readwrite,retain) UILabel* label;
@property (readwrite,assign) ModularConnectionType connectionType;
@property (readwrite,assign) UInt32 index;
@end
