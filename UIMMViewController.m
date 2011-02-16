    //
//  UIMMViewController.m
//  Mod-1
//
//  Created by Schell Scivally on 2/15/11.
//  Copyright 2011 Electrunique. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UIMMViewController.h"
#import "UIViewController+Layout.h"

#define BORDER 2

static CGFloat thirdOfPortraitWidth = 0;

@implementation UIMMViewController

- (id)init {
	self = [super init];
	if (thirdOfPortraitWidth == 0) {
		thirdOfPortraitWidth = [self portraitFrame].size.width/3.0;
	}
	_dragging = NO;
	_viewCreated = NO;
	_backgroundView = nil;
	_windowBarView = nil;
	_contentShadowView = nil;
	_contentView = nil;
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
	[_contentShadowView release];
	[_contentView release];
    [super dealloc];
}

#pragma mark -
#pragma mark View Layout

- (CGFloat)oneThirdPortraitWidth {
	return thirdOfPortraitWidth;
}

- (CGRect)frameForDefault {
	return CGRectMake(0, 0, thirdOfPortraitWidth, thirdOfPortraitWidth);
}

- (CGRect)frameForBackground {
	return [self frameForDefault];
}

- (CGRect)frameForContentShadowView {
	return CGRectMake(BORDER, 50 + BORDER, thirdOfPortraitWidth - 2*BORDER, thirdOfPortraitWidth - 50 - 2*BORDER);
}

- (CGRect)frameForContentView {
	return CGRectMake(0, 0, thirdOfPortraitWidth - 2*BORDER, thirdOfPortraitWidth - 50 - 2*BORDER);
}

#pragma mark -
#pragma mark View Events

- (void)viewWillAppear:(BOOL)animated {
	if (!_viewCreated) {
		[self createView];
	}
}

#pragma mark -
#pragma mark View Creation

- (UIView*)viewForContentView {
	return nil;
}

- (void)createView {
	self.view.frame = [self frameForDefault];
	self.view.backgroundColor = [UIColor clearColor];
	self.view.layer.shadowColor = [[UIColor blackColor] CGColor];
	[self setShadowForState:UIViewStateAtRest];
	
	if (_backgroundView == nil) {
		UIImage* backgroundPattern = [UIImage imageNamed:@"darkbarberpole.png"];
		if (backgroundPattern == nil) {
			[NSException raise:@"could not get background image" format:@"unknown"];
		}
		_backgroundView = [[UIView alloc] initWithFrame:[self frameForBackground]];
		_backgroundView.backgroundColor = [UIColor colorWithPatternImage:backgroundPattern];
	}
	_backgroundView.frame = [self frameForBackground];
	_backgroundView.layer.cornerRadius = 8;
	_backgroundView.layer.masksToBounds = YES;
	[self.view addSubview:_backgroundView];
	
	if (_windowBarView == nil) {
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
	}
	_windowBarView.frame = CGRectMake(0, 0, thirdOfPortraitWidth, 50);
	[_backgroundView addSubview:_windowBarView];
	
	if (_contentShadowView == nil) {
		_contentShadowView = [[UIView alloc] initWithFrame:[self frameForContentShadowView]];
		_contentShadowView.layer.shadowColor = [[UIColor blackColor] CGColor];
		_contentShadowView.layer.shadowOpacity = 1.0f;
		_contentShadowView.layer.shadowOffset = CGSizeMake(0, 0);
	}
	_contentShadowView.frame = [self frameForContentShadowView];
	
	if (_contentView == nil) {
		_contentView = [[UIView alloc] initWithFrame:[self frameForContentView]];
		_contentView.backgroundColor = [UIColor whiteColor];
		_contentView.layer.cornerRadius = 8;
		_contentView.layer.masksToBounds = YES;
	}
	_contentView.frame = [self frameForContentView];
	UIView* contentView = [self viewForContentView];
	if (contentView != nil) {
		[_contentView addSubview:[self viewForContentView]];
	}
	[_contentShadowView addSubview:_contentView];
	[_backgroundView addSubview:_contentShadowView];
	
	if (_icon == nil) {
		_icon = [[UIImageView alloc] initWithImage:[self icon]];
		_icon.layer.shadowColor = [[UIColor blackColor] CGColor];
		_icon.layer.shadowOpacity = 30.0f;
		_icon.layer.shadowRadius = 3;
		_icon.layer.shadowOffset = CGSizeMake(0, 2);
	}
	_icon.frame = CGRectMake(10, 0, 32, 32);
	_icon.center = CGPointMake(_icon.center.x, (_contentShadowView.frame.origin.y)/2);
	[_backgroundView addSubview:_icon];
	
	_viewCreated;
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
#pragma mark View Access

- (UIView*)windowBar {
	return _windowBarView;
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
