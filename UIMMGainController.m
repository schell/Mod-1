    //
//  UIMMGainController.m
//  Mod-1
//
//  Created by Schell Scivally on 2/18/11.
//  Copyright 2011 Electrunique. All rights reserved.
//

#import "UIMMGainController.h"


@implementation UIMMGainController

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
#pragma mark View Customizations

- (NSString*)stringForLabelTitle {
	return @"Gain";
}


@end
