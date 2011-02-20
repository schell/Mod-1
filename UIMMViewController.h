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
	UILabel* _label;
	BOOL _dragging;
	CGPoint _draggingOffset;
	BOOL _viewCreated;
	
}
- (CGFloat)oneThirdPortraitWidth;
- (CGRect)frameForDefault;
- (CGRect)frameForContentView;
- (CGRect)frameForContentShadowView;
- (UIImage*)icon;
- (UIView*)windowBar;
- (UIView*)viewForContentView;
- (NSString*)stringForLabelTitle;
- (void)createView;
- (void)setShadowForState:(UIViewState)state;

@end
