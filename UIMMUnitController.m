    //
//  UIMMUnitController.m
//  Mod-1
//
//  Created by Schell Scivally on 2/6/11.
//  Copyright 2011 Electrunique. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UIMMUnitController.h"
#import "UIViewController+Layout.h"

@implementation UIMMUnitController
@synthesize unit;

#pragma mark -
#pragma mark Lifecycle

- (id)init {
	self = [super init];
	_connectionsController = nil;
	return self;
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


- (void)dealloc {
	[_connectionsController destroy];
	[_connectionsController release];
    [super dealloc];
}

#pragma mark -
#pragma mark View Events

- (void)viewWillAppear:(BOOL)animated {
	if (self.view == nil && self.unit != nil) {
		[self createView];
	}
}

#pragma mark -
#pragma mark View Creation

- (UIView*)viewForContentView {
	if (_connectionsController == nil) {
		_connectionsController = [[UIMMConnectionsController alloc] init];
	}
	_connectionsController.view.frame = [self frameForContentView];
	_connectionsController.view.backgroundColor = [UIColor whiteColor];
	_connectionsController.view.layer.cornerRadius = 8;
	_connectionsController.view.layer.masksToBounds = YES;
	_connectionsController.connections = [self.unit connections];
	[_connectionsController createView];
	return _connectionsController.view;
}

@end
