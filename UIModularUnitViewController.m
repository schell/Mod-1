    //
//  UIModularUnitViewController.m
//  Mod-1
//
//  Created by Schell Scivally on 2/6/11.
//  Copyright 2011 Electrunique. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UIModularUnitViewController.h"
#import "UIViewController+Layout.h"

@implementation UIModularUnitViewController
@synthesize unit;

static CGFloat thirdOfPortraitWidth = 0;

#pragma mark -
#pragma mark Lifecycle

- (id)init {
	self = [super init];
	self.view = nil;
	if (thirdOfPortraitWidth == 0) {
		thirdOfPortraitWidth = [self portraitFrame].size.width/3.0;
	}
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
	[_backgroundView release];
	[_connectionsView release];
	[_inputsController release];
	[_outputsController release];
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
#pragma mark View Creation & Layout

- (void)createView {
	self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, thirdOfPortraitWidth, thirdOfPortraitWidth)];
	self.view.backgroundColor = [UIColor clearColor];
	self.view.layer.shadowColor = [[UIColor blackColor] CGColor];
	self.view.layer.shadowOpacity = 0.5f;
	self.view.layer.shadowRadius = 6;
	self.view.layer.shadowOffset = CGSizeMake(0, 4.0);
	
	_backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, thirdOfPortraitWidth, thirdOfPortraitWidth)];
	_backgroundView.backgroundColor = [UIColor colorWithRed:0.12 green:0.12 blue:0.12 alpha:0.7];
	_backgroundView.layer.cornerRadius = 8;
	_backgroundView.layer.masksToBounds = YES;
	[self.view addSubview:_backgroundView];
	
	_connectionsView = [[UIView alloc] initWithFrame:CGRectMake(1, 51, thirdOfPortraitWidth-2, thirdOfPortraitWidth - 52)];
	_connectionsView.backgroundColor = [UIColor whiteColor];
	_connectionsView.layer.cornerRadius = 8;
	_connectionsView.layer.masksToBounds = YES;
	[self.view addSubview:_connectionsView];
	
	NSArray* connections = [self.unit connections];
	//_inputConnections = [NSMutableArray array];
//	_outputConnections = [NSMutableArray array];
//	for (int i = 0; i < [connections count]; i++) {
//		ModularConnection*
//	}
}

- (CGFloat)oneThirdPortraitWidth {
	return thirdOfPortraitWidth;
}

@end
