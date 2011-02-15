//
//  UIConnectionView.h
//  Mod-1
//
//  Created by Schell Scivally on 2/14/11.
//  Copyright 2011 Electrunique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UISocketView.h"

@interface UIConnectionView : UIView {}
@property (readwrite,retain) UISocketView* socketView;
@property (readwrite,retain) UILabel* label;
@end
