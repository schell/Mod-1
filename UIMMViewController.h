//
//  UIMMViewController.h
//  Mod-1
//
//  Created by Schell Scivally on 2/15/11.
//  Copyright 2011 Electrunique. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	UIViewStateAtRest,
	UIViewStateDragging
} UIViewState;

@interface UIMMViewController : UIViewController {
	UIView* _icon;
	UIView* _backgroundView;
	UIView* _windowBarView;
	UIView* _contentShadowView;
	UIView* _contentView;
	BOOL _dragging;
	CGPoint _draggingOffset;
	BOOL _viewCreated;
	
}
- (CGFloat)oneThirdPortraitWidth;
- (CGRect)frameForDefault;
- (CGRect)frameForContentView;
- (CGRect)frameForContentShadowView;
- (void)createView;
- (UIImage*)icon;
- (void)setShadowForState:(UIViewState)state;
- (UIView*)windowBar;
- (UIView*)viewForContentView;
@end
