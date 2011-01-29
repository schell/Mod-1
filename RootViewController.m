    //
//  RootViewController.m
//  Mod-1
//
//  Created by Schell Scivally on 1/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"

@implementation RootViewController

#pragma mark -
#pragma mark LifeCycle

- (id)init {
	self = [super init];
	_rootAudioController = [[RootAudioController alloc] init];
	return self;
}

- (void)dealloc {
    [super dealloc];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
	switch (interfaceOrientation) {
		case UIInterfaceOrientationPortrait:
		case UIInterfaceOrientationPortraitUpsideDown:
		case UIInterfaceOrientationLandscapeLeft:
		case UIInterfaceOrientationLandscapeRight:
			return YES;
		default:
			return NO;
	}
}


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

- (void)viewWillAppear:(BOOL)animated {
	NSLog(@"%s",__FUNCTION__);
	self.view.backgroundColor = [UIColor purpleColor];
}

#pragma mark -
#pragma mark Layout

+ (CGSize)portraitSize {
	CGSize size = [[UIScreen mainScreen] applicationFrame].size;
	if (size.width > size.height) {
		return CGSizeMake(size.height, size.width);
	}
	return size;
}

+ (CGSize)landscapeSize {
	CGSize portrait;
	return CGSizeMake(portrait.height, portrait.width);
}

@end
