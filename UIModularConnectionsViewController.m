    //
//  UIModularConnectionsViewController.m
//  Mod-1
//
//  Created by Schell Scivally on 2/13/11.
//  Copyright 2011 Electrunique. All rights reserved.
//

#import "UIModularConnectionsViewController.h"
#import "ModularConnection.h"
#import "UISocketView.h"

@implementation UIModularConnectionsViewController
@synthesize connections;

- (id)init {
	self = [super init];
	connections = nil;
	_headerView = nil;
	_inputViews = nil;
	_outputViews = nil;
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
#pragma mark Connections

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

- (UIColor*)connectionsColor {
	return [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
}

- (UIView*)inputViewAtIndex:(UInt32)index {
	if (_inputViews != nil && [_inputViews count] > index) {
		return [_inputViews objectAtIndex:index];
	}
	
	CGRect headerViewFrame = [self frameForHeader];
	UIView* input = [[[UIView alloc] initWithFrame:CGRectMake(headerViewFrame.size.width/2, headerViewFrame.size.height * (index + 1), headerViewFrame.size.width/2, headerViewFrame.size.height)] autorelease];
	input.backgroundColor = [self connectionsColor];
	
	ModularConnection* connection = [_inputConnections objectAtIndex:index];
	if (connection == nil) {
		connection = [[[ModularConnection alloc] init] autorelease];
	}
	
	UILabel* connectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, input.frame.size.width, input.frame.size.height)];
	connectionLabel.text = [NSString stringWithFormat:@"   %@",[connection name]];
	connectionLabel.font = [UIFont systemFontOfSize:15.0];
	connectionLabel.backgroundColor = [UIColor clearColor];
	connectionLabel.textColor = [UIColor darkGrayColor];
	connectionLabel.textAlignment = UITextAlignmentLeft;
	[input addSubview:connectionLabel];
	
	CGFloat radius = 10.0;
	UISocketView* socket = [[[UISocketView alloc] initWithFrame:CGRectMake(input.frame.size.width - radius*2 - 10, input.frame.size.height/2 - radius, radius*2, radius*2)] autorelease];
	[input addSubview:socket];
	
	return input;
}

- (UIView*)outputViewAtIndex:(UInt32)index {
	if (_outputViews != nil && [_outputViews count] > index) {
		return [_outputViews objectAtIndex:index];
	}
	
	CGRect headerViewFrame = [self frameForHeader];
	UIView* output = [[[UIView alloc] initWithFrame:CGRectMake(0, headerViewFrame.size.height * (index + 1), headerViewFrame.size.width/2, headerViewFrame.size.height)] autorelease];
	output.backgroundColor = [self connectionsColor];
	return output;
}

- (void)createView {
	if (_headerView == nil) {
		_headerView = [[UIView alloc] initWithFrame:[self frameForHeader]];
		
		UILabel* outputLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _headerView.frame.size.width/2, _headerView.frame.size.height)];
		outputLabel.text = @"  Output";
		outputLabel.font = [UIFont boldSystemFontOfSize:20.0];
		outputLabel.backgroundColor = [self connectionsColor];
		outputLabel.textColor = [UIColor darkGrayColor];
		outputLabel.textAlignment = UITextAlignmentLeft;
		[_headerView addSubview:outputLabel];
		
		UILabel* inputLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headerView.frame.size.width/2, 0, _headerView.frame.size.width/2, _headerView.frame.size.height)];
		inputLabel.text = @"Input  ";
		inputLabel.font = [UIFont boldSystemFontOfSize:20.0];
		inputLabel.backgroundColor = outputLabel.backgroundColor;
		inputLabel.textColor = outputLabel.textColor;
		inputLabel.textAlignment = UITextAlignmentRight;
		[_headerView addSubview:inputLabel];
		
		_inputViews = [[NSMutableArray array] retain];
		_outputViews = [[NSMutableArray array] retain];
		_inputConnections = [[NSMutableArray array] retain];
		_outputConnections = [[NSMutableArray array] retain];
		
		for (UInt32 i = 0; i < [connections count]; i++) {
			ModularConnection* connection = [self.connections objectAtIndex:i];
			UIView* connectionView = nil;
			
			switch (connection.type) {
				case ModularConnectionTypeInput:
					[_inputConnections addObject:connection];
					connectionView = [self inputViewAtIndex:i];
					[_inputViews addObject:connectionView];
					break;
				case ModularConnectionTypeOutput:
					[_outputConnections addObject:connection];
					connectionView = [self outputViewAtIndex:i];
					[_outputViews addObject:connectionView];
					break;
				case ModularConnectionTypeNone:
				default:
					break;
			}
			if (connectionView != nil) {
				[self.view addSubview:connectionView];
			}
		}
		
		[self.view addSubview:_headerView];
	}
}


@end
	