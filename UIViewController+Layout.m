    //
//  UITableViewController+Layout.m
//  CocoaViewer
//
//  Created by Schell Scivally on 2/4/11.
//  Copyright 2011 Synapse Group International, Inc. All rights reserved.
//

#import "UIViewController+Layout.h"


@implementation UIViewController (Layout)

- (CGRect)portraitFrame {
	CGRect portrait = [[UIScreen mainScreen] applicationFrame];
	if (portrait.size.width > portrait.size.height) {
		return CGRectMake(portrait.origin.x, portrait.origin.y, portrait.size.height, portrait.size.width);
	}
	return portrait;
}

- (CGRect)landscapeFrame {
	CGRect portrait = [self portraitFrame];
	CGRect landscape = portrait;
	landscape.size = CGSizeMake(portrait.size.height, portrait.size.width);
	return landscape;
}

- (CGRect)viewFrameWithOrientation:(UIDeviceOrientation)orientation {
	CGRect viewFrame = {0};
	switch (orientation) {
		case UIDeviceOrientationLandscapeLeft: // fall through
		case UIDeviceOrientationLandscapeRight:
			viewFrame = [self landscapeFrame];
			break;
			
		case UIDeviceOrientationPortrait: // fall through
		case UIDeviceOrientationPortraitUpsideDown: // fall through
		default:
			viewFrame = [self portraitFrame];
			break;
	}
	return viewFrame;
}

@end
