//
//  UISocketView.m
//  Mod-1
//
//  Created by Schell Scivally on 2/14/11.
//  Copyright 2011 Electrunique. All rights reserved.
//

#import "UISocketView.h"

#define SQRT2_OVER_2 0.707106781186

@implementation UISocketView
@synthesize active,socketColor,wireColor;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		socketColor = [UIColor darkGrayColor];
		wireColor = [UIColor greenColor];
		self.backgroundColor = [UIColor clearColor];
		self.active = NO;
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark -
#pragma mark Drawing

+ (void)drawOpenSocketInContext:(CGContextRef)context atPoint:(CGPoint)point withRadius:(CGFloat)radius andColor:(UIColor*)color {
	CGContextSetLineWidth(context, 2);
	[color setStroke];
	[color setFill];
	CGContextAddArc(context, point.x, point.y, radius, 0, 2*M_PI, YES);
	CGContextStrokePath(context);
	CGContextAddArc(context, point.x, point.y, radius-3, 0, 2*M_PI, YES);
	CGContextFillPath(context);
}

+ (void)drawClosedSocketInContext:(CGContextRef)context atPoint:(CGPoint)point withRadius:(CGFloat)radius andColor:(UIColor*)color {
	CGFloat xWidth = 1;
	CGFloat innerArcLength = xWidth*M_PI/2;
	CGFloat outerRadianOffset = innerArcLength/radius;
	CGContextSetLineWidth(context, 2);
	[color setStroke];
	[color setFill];
	CGContextAddArc(context, point.x, point.y, radius, 0, 2*M_PI, YES);
	CGContextStrokePath(context);
	CGContextMoveToPoint(context, point.x, point.y+xWidth);
	CGContextAddArc(context, point.x, point.y/2, radius-2, M_PI/4+outerRadianOffset, 3*M_PI/4-outerRadianOffset, NO);
	CGContextMoveToPoint(context, point.x-xWidth, point.y/2);
	CGContextAddArc(context, point.x, point.y/2, radius-2, 3*M_PI/4+outerRadianOffset, 5*M_PI/4-outerRadianOffset, NO);
	CGContextMoveToPoint(context, point.x, point.y/2-xWidth);
	CGContextAddArc(context, point.x, point.y/2, radius-2, 5*M_PI/4+outerRadianOffset, 7*M_PI/4-outerRadianOffset, NO);
	CGContextMoveToPoint(context, point.x+xWidth, point.y/2);
	CGContextAddArc(context, point.x, point.y/2, radius-2, 7*M_PI/4+outerRadianOffset, M_PI/4-outerRadianOffset, NO);
	CGContextFillPath(context);
}

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGPoint point = CGPointMake(rect.size.width/2, rect.size.height/2);
	CGFloat radius = point.x - 1;
	BOOL activated = self.active;
	
	if (activated) {
		[UISocketView drawClosedSocketInContext:context atPoint:point withRadius:radius andColor:socketColor];
	} else {
		[UISocketView drawOpenSocketInContext:context atPoint:point withRadius:radius andColor:socketColor];
	}
	CGContextFillPath(context);
}

@end
