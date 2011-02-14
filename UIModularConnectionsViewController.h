//
//  UIModularConnectionsViewController.h
//  Mod-1
//
//  Created by Schell Scivally on 2/13/11.
//  Copyright 2011 Electrunique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIModularConnectionsViewController : UIViewController {
	UIView* _header;
}
+ (UIView*)sharedWireDisplayView;
- (void)createView;
@property (readwrite,retain) NSArray* connections;
@end
