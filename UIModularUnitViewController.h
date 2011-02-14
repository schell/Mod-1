//
//  UIModularUnitViewController.h
//  Mod-1
//
//  Created by Schell Scivally on 2/6/11.
//  Copyright 2011 Electrunique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModularUnit.h"
#import "UIModularConnectionsTableViewController.h"

typedef enum {
	UIViewStateAtRest,
	UIViewStateDragging
} UIViewState;

@interface UIModularUnitViewController : UIViewController {
	ModularUnit* unit;
	UIView* _icon;
	UIView* _backgroundView;
	UIView* _windowBarView;
	UIModularConnectionsTableViewController* _connectionsTableController;
	BOOL _dragging;
	CGPoint _draggingOffset;
}
- (CGFloat)oneThirdPortraitWidth;
- (void)createView;
- (UIImage*)icon;
- (void)setShadowForState:(UIViewState)state;
@property (readwrite,retain) ModularUnit* unit;
@end
