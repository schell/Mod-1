//
//  RootViewController.h
//  Mod-1
//
//  Created by Schell Scivally on 1/25/11.
//  Copyright 2011 Electrunique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootAudioController.h"
#import "UIMMMenuController.h"
#import "UIMMHeadUnitController.h"

@interface RootViewController : UIViewController {
	RootAudioController* _rootAudioController;
	UIMMHeadUnitController* _headUnitViewController;
	UIMMMenuController* _menuController;
	UITapGestureRecognizer* _twoFingerSingleTap;
	UIView* _unitViews;
	NSMutableSet* _unitControllers;
}
+ (CGSize)portraitSize;
+ (CGSize)landscapeSize;
- (void)didSingleTapWithTwoFingers:(UITapGestureRecognizer*)tap;
@end
