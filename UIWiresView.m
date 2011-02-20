//
//  UIWiresView.m
//  Mod-1
//
//  Created by Schell Scivally on 2/18/11.
//  Copyright 2011 Electrunique. All rights reserved.
//

#import "UIWiresView.h"
#import "UISocketView.h"

@implementation UIWiresView
@synthesize wires;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		self.userInteractionEnabled = NO;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextClearRect(context, rect);
	NSMutableArray* allWires = [NSMutableArray arrayWithArray:wires];
	[allWires addObjectsFromArray:temporaryWires];
	int numPoints = [allWires count];
	assert(numPoints%2 == 0);
	for (int i = 0; i < numPoints; i+=2) {
		NSValue* pointValue = [allWires objectAtIndex:i];
		CGPoint start = [pointValue CGPointValue];
		
		CGContextSetLineWidth(context, 6);
		CGContextSetLineCap(context, kCGLineCapRound);
		[[UIColor grayColor] setStroke];
		CGContextMoveToPoint(context, start.x, start.y);
		
		pointValue = [allWires objectAtIndex:i+1];
		CGPoint end = [pointValue CGPointValue];
		CGContextSetLineWidth(context, 6);
		CGContextSetLineCap(context, kCGLineCapRound);
		CGContextAddLineToPoint(context, end.x, end.y);
		
		CGContextStrokePath(context);
		[UISocketView drawOpenSocketInContext:context atPoint:start withRadius:6 andColor:[UIColor grayColor]];
		[UISocketView drawOpenSocketInContext:context atPoint:end withRadius:6 andColor:[UIColor grayColor]];
	}
	[temporaryWires removeAllObjects];
}


- (void)dealloc {
    [super dealloc];
}

#pragma mark -
#pragma mark Wires

- (void)addTemporaryWireWithStart:(CGPoint)start andEnd:(CGPoint)end {
	if (temporaryWires == nil) {
		temporaryWires = [[NSMutableArray alloc] init];
	}
	[temporaryWires addObject:[NSValue valueWithCGPoint:start]];
	[temporaryWires addObject:[NSValue valueWithCGPoint:end]];
}

- (void)drawTemporaryWireWithStart:(CGPoint)start andEnd:(CGPoint)end {
	[self addTemporaryWireWithStart:start andEnd:end];
	[self setNeedsDisplay];
}


@end
