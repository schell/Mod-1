//
//  RootViewController.h
//  Mod-1
//
//  Created by Schell Scivally on 1/25/11.
//  Copyright 2011 Electrunique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootAudioController.h"
#import "UIModularUnitViewController.h"

@interface RootViewController : UIViewController {
	RootAudioController* _rootAudioController;
	UILabel* _label;
	UIModularUnitViewController* _headUnitViewController;
}
+ (CGSize)portraitSize;
+ (CGSize)landscapeSize;
- (CGPoint)normalizeScreenCoordinates:(CGPoint)loc;
- (void)setVolumeAndFrequencyUsingPoint:(CGPoint)loc;
- (void)setLabelText:(NSString*)text;
@end
