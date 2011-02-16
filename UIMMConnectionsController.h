//
//  UIMMConnectionsController.h
//  Mod-1
//
//  Created by Schell Scivally on 2/13/11.
//  Copyright 2011 Electrunique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UIConnectionView.h"

@interface UIMMConnectionsController : UIViewController {
	UIView* _headerView;
	NSMutableArray* _inputViews;
	NSMutableArray* _outputViews;
	NSMutableArray* _inputConnections;
	NSMutableArray* _outputConnections;
}
+ (UIView*)sharedWireDisplayView;
- (UIColor*)connectionsColor;
- (UIConnectionView*)inputViewAtIndex:(UInt32)index;
- (UIConnectionView*)outputViewAtIndex:(UInt32)index;
- (void)createView;
@property (readwrite,retain) NSArray* connections;
@end
