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
	_dragging = NO;
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
	[_windowBarView release];
	[_icon release];
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
#pragma mark Layout

- (CGRect)frameForDefault {
	return CGRectMake(0, 0, thirdOfPortraitWidth, thirdOfPortraitWidth);
}

- (CGRect)frameForBackground {
	return [self frameForDefault];
}

- (CGRect)frameForConnectionsTableView {
	int border = 2;
	return CGRectMake(border, 50 + border, thirdOfPortraitWidth - 2*border, thirdOfPortraitWidth - 50 - 2*border);
}

#pragma mark -
#pragma mark View Creation

- (void)createView {
	self.view = [[[UIView alloc] initWithFrame:[self frameForDefault]] autorelease];
	self.view.backgroundColor = [UIColor clearColor];
	self.view.layer.shadowColor = [[UIColor blackColor] CGColor];
	[self setShadowForState:UIViewStateAtRest];
	
	UIImage* backgroundPattern = [UIImage imageNamed:@"darkbarberpole.png"];
	if (backgroundPattern == nil) {
		[NSException raise:@"could not get background image" format:@"unknown"];
	}
	_backgroundView = [[UIView alloc] initWithFrame:[self frameForBackground]];
	_backgroundView.backgroundColor = [UIColor colorWithPatternImage:backgroundPattern];
	_backgroundView.layer.cornerRadius = 8;
	_backgroundView.layer.masksToBounds = YES;
	[self.view addSubview:_backgroundView];
	
	UIImage* windowBarBackground = [UIImage imageNamed:@"darkbarberpole.png"];
	if (windowBarBackground == nil) {
		[NSException raise:@"could not get windowbar background image" format:@"unknown"];
	}
	UIView* highlight = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, thirdOfPortraitWidth, 1)] autorelease];
	highlight.backgroundColor = [UIColor whiteColor];
	highlight.alpha = 0.1;
	_windowBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, thirdOfPortraitWidth, 50)];
	_windowBarView.backgroundColor = [UIColor colorWithPatternImage:windowBarBackground];
	[_windowBarView addSubview:highlight];
	[_backgroundView addSubview:_windowBarView];
	
	UIView* connectionsShadow = [[[UIView alloc] initWithFrame:[self frameForConnectionsTableView]] autorelease];
	connectionsShadow.layer.shadowColor = [[UIColor blackColor] CGColor];
	connectionsShadow.layer.shadowOpacity = 1.0f;
	connectionsShadow.layer.shadowOffset = CGSizeMake(0, 0);
	_connectionsController = [[UIModularConnectionsViewController alloc] init];
	_connectionsController.view.frame = CGRectMake(0, 0, connectionsShadow.frame.size.width, connectionsShadow.frame.size.height);
	_connectionsController.view.backgroundColor = [UIColor whiteColor];
	_connectionsController.view.layer.cornerRadius = 8;
	_connectionsController.view.layer.masksToBounds = YES;
	_connectionsController.connections = [self.unit connections];
	[_connectionsController createView];
	[connectionsShadow addSubview:_connectionsController.view];
	[_backgroundView addSubview:connectionsShadow];
	
	_icon = [[UIImageView alloc] initWithImage:[self icon]];
	_icon.frame = CGRectMake(10, 0, 32, 32);
	_icon.center = CGPointMake(_icon.center.x, (connectionsShadow.frame.origin.y)/2);
	_icon.layer.shadowColor = [[UIColor blackColor] CGColor];
	_icon.layer.shadowOpacity = 30.0f;
	_icon.layer.shadowRadius = 3;
	_icon.layer.shadowOffset = CGSizeMake(0, 2);
	[_backgroundView addSubview:_icon];
}

- (CGFloat)oneThirdPortraitWidth {
	return thirdOfPortraitWidth;
}

#pragma mark -
#pragma mark View Access

- (UIView*)windowBar {
	return _windowBarView;
}

#pragma mark -
#pragma mark View Customizations

- (UIImage*)icon {
	return [UIImage imageNamed:@"icon.png"];
}

- (void)setShadowForState:(UIViewState)state {
	switch (state) {
		case UIViewStateAtRest:
			self.view.layer.shadowOpacity = 0.7f;
			self.view.layer.shadowRadius = 6;
			self.view.layer.shadowOffset = CGSizeMake(0, 4.0);
			break;
		case UIViewStateDragging:
			self.view.layer.shadowOpacity = 0.7f;
			self.view.layer.shadowRadius = 10;
			self.view.layer.shadowOffset = CGSizeMake(0, 4.0);
			break; //UIInterfaceOrientation
		default:
			break;
	}
}

#pragma mark -
#pragma mark Dragging

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"%s",__FUNCTION__);
	UITouch* tap = [touches anyObject];
	CGPoint loc = [tap locationInView:_backgroundView];
	if (CGRectContainsPoint(_windowBarView.frame, loc)) {
		_dragging = YES;
		_draggingOffset = loc;
		[self setShadowForState:UIViewStateDragging];
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	if (_dragging) {
		UITouch* tap = [touches anyObject];
		CGPoint loc = [tap locationInView:self.view.superview];
		CGRect viewFrame = self.view.frame;
		viewFrame.origin = CGPointMake(loc.x - _draggingOffset.x, loc.y - _draggingOffset.y);
		self.view.frame = viewFrame;
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if (self.view.frame.origin.x < 0 || self.view.frame.origin.y < 0) {
		CGPoint point = {0};
		point.x = self.view.frame.origin.x < 0 ? self.view.frame.size.width/2 : self.view.center.x;
		point.y = self.view.frame.origin.y < 0 ? self.view.frame.size.height/2 : self.view.center.y;
		[UIView animateWithDuration:0.3 animations:^{
			self.view.center = point;
		}];
	}
	_dragging = NO;
	[self setShadowForState:UIViewStateAtRest];
}

@end
