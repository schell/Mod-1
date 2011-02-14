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

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	CGFloat xWidth = 1;
	CGFloat innerArcLength = xWidth*M_PI/2;
	CGFloat radius = rect.size.width/2;
	CGFloat outerRadianOffset = innerArcLength/radius;
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetLineWidth(context, 2);
	[socketColor setStroke];
	[socketColor setFill];
    // draw the socket
	CGContextAddArc(context, radius, rect.size.height/2, radius-1, 0, 2*M_PI, YES);
	CGContextStrokePath(context);
	BOOL activated = self.active;
	if (activated) {
		CGContextMoveToPoint(context, radius, rect.size.height/2+xWidth);
		CGContextAddArc(context, radius, rect.size.height/2, radius-3, M_PI/4+outerRadianOffset, 3*M_PI/4-outerRadianOffset, NO);
		CGContextMoveToPoint(context, radius-xWidth, rect.size.height/2);
		CGContextAddArc(context, radius, rect.size.height/2, radius-3, 3*M_PI/4+outerRadianOffset, 5*M_PI/4-outerRadianOffset, NO);
		CGContextMoveToPoint(context, radius, rect.size.height/2-xWidth);
		CGContextAddArc(context, radius, rect.size.height/2, radius-3, 5*M_PI/4+outerRadianOffset, 7*M_PI/4-outerRadianOffset, NO);
		CGContextMoveToPoint(context, radius+xWidth, rect.size.height/2);
		CGContextAddArc(context, radius, rect.size.height/2, radius-3, 7*M_PI/4+outerRadianOffset, M_PI/4-outerRadianOffset, NO);
	} else {
		CGContextAddArc(context, radius, rect.size.height/2, radius-4, 0, 2*M_PI, YES);
	}
	CGContextFillPath(context);
}

- (void)dealloc {
    [super dealloc];
}


@end
