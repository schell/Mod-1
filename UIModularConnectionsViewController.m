    //
//  UIModularConnectionsViewController.m
//  Mod-1
//
//  Created by Schell Scivally on 2/13/11.
//  Copyright 2011 Electrunique. All rights reserved.
//

#import "UIModularConnectionsViewController.h"


@implementation UIModularConnectionsViewController
@synthesize connections;

- (id)init {
	self = [super init];
	connections = nil;
	_header = nil;
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
    [super dealloc];
}

#pragma mark -
#pragma mark Shared
+ (UIView*)sharedWireDisplayView {
	static UIView* wireView = nil;
	if (wireView == nil) {
		wireView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	}
	return wireView;
}

#pragma mark -
#pragma mark View Layout

- (CGRect)frameForHeader {
	return CGRectMake(0, 0, self.view.frame.size.width, 40);
}

#pragma mark -
#pragma mark View Events

- (void)viewWillAppear:(BOOL)animated {
}

#pragma mark -
#pragma mark View Creation

- (void)createView {
	if (_header == nil) {
		_header = [[UIView alloc] initWithFrame:[self frameForHeader]];
		
		UILabel* outputs = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _header.frame.size.width/2, _header.frame.size.height)];
		outputs.text = @"  Output";
		outputs.font = [UIFont boldSystemFontOfSize:20.0];
		outputs.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
		outputs.textColor = [UIColor darkGrayColor];
		outputs.textAlignment = UITextAlignmentLeft;
		[_header addSubview:outputs];
		
		UILabel* inputs = [[UILabel alloc] initWithFrame:CGRectMake(_header.frame.size.width/2, 0, _header.frame.size.width/2, _header.frame.size.height)];
		inputs.text = @"Input  ";
		inputs.font = [UIFont boldSystemFontOfSize:20.0];
		inputs.backgroundColor = outputs.backgroundColor;
		inputs.textColor = outputs.textColor;
		inputs.textAlignment = UITextAlignmentRight;
		[_header addSubview:inputs];
		
		[self.view addSubview:_header];
	}
}


@end
	