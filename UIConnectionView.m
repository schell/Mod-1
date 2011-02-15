//
//  UIConnectionView.m
//  Mod-1
//
//  Created by Schell Scivally on 2/14/11.
//  Copyright 2011 Electrunique. All rights reserved.
//

#import "UIConnectionView.h"


@implementation UIConnectionView
@synthesize socketView,label;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
    [super dealloc];
}


@end
