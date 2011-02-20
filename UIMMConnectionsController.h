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
#import "UIWiresView.h"

@interface UIMMConnectionsController : UIViewController {
	UIView* _headerView;
	NSMutableArray* _inputViews;
	NSMutableArray* _outputViews;
	NSMutableArray* _inputConnections;
	NSMutableArray* _outputConnections;
	UIConnectionView* _connectionViewBeingWired;
	CGPoint _temporaryWireStart;
	CGPoint _temporaryWireEnd;
}
+ (UIWiresView*)sharedWireDisplayView;
+ (void)wireConnectionView:(UIConnectionView*)connectionView to:(UIConnectionView*)connectionViewBeingWired;
+ (NSArray*)wiredSocketPairs;
- (UIColor*)connectionsColor;
- (UIConnectionView*)inputViewAtIndex:(UInt32)index;
- (UIConnectionView*)outputViewAtIndex:(UInt32)index;
- (UIConnectionView*)connectionViewAtIndex:(UInt32)index onLeft:(BOOL)left;
- (NSSet*)inputViews;
- (NSSet*)outputViews;
- (NSSet*)allConnectionViews;
- (void)createView;
- (void)destroy;
- (UIConnectionView*)setTemporaryWireAndGetConnectionViewAtPoint:(CGPoint)point;
@property (readwrite,retain) NSArray* connections;
@end
