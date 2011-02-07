    //
//  RootViewController.m
//  Mod-1
//
//  Created by Schell Scivally on 1/25/11.
//  Copyright 2011 Electrunique. All rights reserved.
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
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

#pragma mark -
#pragma mark View

- (void)setLabelText:(NSString*)text {
	_label.text = text;
	CGRect labelFrame = CGRectMake(0, 0, 0, 0);
	labelFrame.size = [_label.text sizeWithFont:_label.font];
	_label.frame = labelFrame;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
	NSLog(@"%s",__FUNCTION__);
	self.view.backgroundColor = [UIColor clearColor];
	if (![[self.view subviews] count]) {
		_label = [[UILabel alloc] init];
		[self setLabelText:@"Mod-1 Synthesizer"];
		[self.view addSubview:_label];
		_headUnitViewController = [[UIModularUnitViewController alloc] init];
		_headUnitViewController.unit = [_rootAudioController mainGraph].headUnit;
		[self.view addSubview:_headUnitViewController.view];
	}
}

- (void)viewDidAppear:(BOOL)animated {
	NSLog(@"%s",__FUNCTION__);
	[_rootAudioController startGraph];
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch* anyTouch = [touches anyObject];
	CGPoint loc = [self normalizeScreenCoordinates:[anyTouch locationInView:self.view]];
	NSLog(@"%s%f %f",__FUNCTION__,loc.x,loc.y);
	[self setVolumeAndFrequencyUsingPoint:loc];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch* anyTouch = [touches anyObject];
	CGPoint loc = [self normalizeScreenCoordinates:[anyTouch locationInView:self.view]];
	NSLog(@"%s%f %f",__FUNCTION__,loc.x,loc.y);
	[self setVolumeAndFrequencyUsingPoint:loc];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch* anyTouch = [touches anyObject];
	CGPoint loc = [self normalizeScreenCoordinates:[anyTouch locationInView:self.view]];
	NSLog(@"%s%f %f",__FUNCTION__,loc.x,loc.y);
	[self setVolumeAndFrequencyUsingPoint:loc];
}

#pragma mark -
#pragma mark Config

- (void)setVolumeAndFrequencyUsingPoint:(CGPoint)loc {
	CGFloat freq = 5000.0f * loc.x;
	CGFloat volume = loc.y;
	[self setLabelText:[NSString stringWithFormat:@"freq:%0.2f vol:%0.2f",freq,volume]];
	[_rootAudioController mainGraph].headUnit.defaultGain = volume * INT16_MAX;
}

@end
