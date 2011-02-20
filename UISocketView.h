//
//  UISocketView.h
//  Mod-1
//
//  Created by Schell Scivally on 2/14/11.
//  Copyright 2011 Electrunique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISocketView : UIView {}
+ (void)drawOpenSocketInContext:(CGContextRef)context atPoint:(CGPoint)point withRadius:(CGFloat)radius andColor:(UIColor*)color;
+ (void)drawClosedSocketInContext:(CGContextRef)context atPoint:(CGPoint)point withRadius:(CGFloat)radius andColor:(UIColor*)color;
@property (readwrite,assign) BOOL active;
@property (readwrite,retain) UIColor* socketColor;
@property (readwrite,retain) UIColor* wireColor;
@end
