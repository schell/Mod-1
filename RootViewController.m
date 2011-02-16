    //
//  RootViewController.m
//  Mod-1
//
//  Created by Schell Scivally on 1/25/11.
//  Copyright 2011 Electrunique. All rights reserved.
//

#import "RootViewController.h"
#import "UIViewController+Layout.h"
#import "UIMMConnectionsController.h"
#import "UIMMMenuController.h"

@implementation RootViewController

#pragma mark -
#pragma mark Statics

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

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

#pragma mark -
#pragma mark View

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
	NSLog(@"%s",__FUNCTION__);
	self.view.backgroundColor = [UIColor clearColor];
	if (![[self.view subviews] count]) {
		_headUnitViewController = [[UIMMUnitController alloc] init];
		_headUnitViewController.unit = [_rootAudioController mainGraph].headUnit;
		[_headUnitViewController createView];
		[self.view addSubview:_headUnitViewController.view];
		CGRect frame = _headUnitViewController.view.frame;
		frame.origin = CGPointMake(100, 100);
		_headUnitViewController.view.frame = frame;
		// add the shared wire view
		[self.view addSubview:[UIMMConnectionsController sharedWireDisplayView]];
		// add a two finger single tap recognizer
		_twoFingerSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSingleTapWithTwoFingers:)];
		_twoFingerSingleTap.numberOfTouchesRequired = 2;
		[self.view addGestureRecognizer:_twoFingerSingleTap];
	}
	[_rootAudioController mainGraph].headUnit.defaultGain = 0;
}

- (void)viewDidAppear:(BOOL)animated {
	NSLog(@"%s",__FUNCTION__);
	[_rootAudioController startGraph];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	switch (toInterfaceOrientation) {
		case UIInterfaceOrientationLandscapeLeft:
		case UIInterfaceOrientationLandscapeRight:
		case UIInterfaceOrientationPortrait:
		case UIInterfaceOrientationPortraitUpsideDown:
			return YES;
		default:
			return NO;
	}
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	NSLog(@"%s",__FUNCTION__);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	NSLog(@"%s",__FUNCTION__);
	CGRect viewFrame = [self viewFrameWithOrientation:toInterfaceOrientation];
	[UIMMConnectionsController sharedWireDisplayView].frame = viewFrame;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	NSLog(@"%s",__FUNCTION__);
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
	CGSize portrait = [RootViewController portraitSize];
	return CGSizeMake(portrait.height, portrait.width);
}

#pragma mark -
#pragma mark Utility Functions

- (CGPoint)normalizeScreenCoordinates:(CGPoint)loc {
	CGRect rect = self.view.frame;
	switch ([[UIDevice currentDevice] orientation]) {
		case UIDeviceOrientationPortrait:
		case UIDeviceOrientationPortraitUpsideDown:
			rect.size = [RootViewController portraitSize];
		break;
			
		case UIDeviceOrientationLandscapeLeft:
		case UIDeviceOrientationLandscapeRight:
			rect.size = [RootViewController landscapeSize];
		break;

		default:
		break;
	}
	loc.x = loc.x/rect.size.width;
	loc.y = loc.y/rect.size.height;
	return loc;
}

#pragma mark -
#pragma mark User Interaction

- (void)didSingleTapWithTwoFingers:(UITapGestureRecognizer *)tap {
	NSLog(@"%s",__FUNCTION__);
	CGPoint loc = [tap locationInView:self.view];
	if (_menuController == nil) {
		_menuController = [[UIMMMenuController alloc] init];
		_menuController.view.backgroundColor = [UIColor whiteColor];
		_menuController.view.frame = CGRectMake(0, 0, [_headUnitViewController oneThirdPortraitWidth], [_headUnitViewController oneThirdPortraitWidth]);
		[_menuController createView];
	}
	_menuController.view.center = loc;
	[self.view addSubview:_menuController.view];
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//
//}
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//}

#pragma mark -
#pragma mark Config

- (void)setVolumeAndFrequencyUsingPoint:(CGPoint)loc {
}

@end
