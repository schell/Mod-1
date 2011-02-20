    //
//  UIMMHeadUnitController.m
//  Mod-1
//
//  Created by Schell Scivally on 2/17/11.
//  Copyright 2011 Electrunique. All rights reserved.
//

#import "UIMMHeadUnitController.h"


@implementation UIMMHeadUnitController


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

#pragma mark -
#pragma mark UIMMViewController

- (UIImage*)icon {
	return [UIImage imageNamed:@"speaker.png"];
}

- (NSString*)stringForLabelTitle {
	return @"Speakers";
}


@end
