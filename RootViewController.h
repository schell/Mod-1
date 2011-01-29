//
//  RootViewController.h
//  Mod-1
//
//  Created by Schell Scivally on 1/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootAudioController.h"

@interface RootViewController : UIViewController {
	RootAudioController* _rootAudioController;
}
+ (CGSize)portraitSize;
+ (CGSize)landscapeSize;
@end
