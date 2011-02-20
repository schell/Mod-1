//
//  UIConnectionView.m
//  Mod-1
//
//  Created by Schell Scivally on 2/14/11.
//  Copyright 2011 Electrunique. All rights reserved.
//

#import "UIConnectionView.h"
#import "UIMMConnectionsController.h"

@implementation UIConnectionView
@synthesize socketView,label,connectionType,index,wiredConnectionView,controller;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		connectionType = ModularConnectionTypeNone;
		index = UINT32_MAX;
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
