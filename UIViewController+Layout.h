//
//  UITableViewController+Layout.h
//  CocoaViewer
//
//  Created by Schell Scivally on 2/4/11.
//  Copyright 2011 Synapse Group International, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Layout)
- (CGRect)portraitFrame;
- (CGRect)landscapeFrame;
- (CGRect)viewFrameWithOrientation:(UIDeviceOrientation)orientation;
@end