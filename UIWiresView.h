//
//  UIWiresView.h
//  Mod-1
//
//  Created by Schell Scivally on 2/18/11.
//  Copyright 2011 Electrunique. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIWiresView : UIView {
	NSMutableArray* temporaryWires;
}
- (void)addTemporaryWireWithStart:(CGPoint)start andEnd:(CGPoint)end;
- (void)drawTemporaryWireWithStart:(CGPoint)start andEnd:(CGPoint)end;
@property (readwrite,retain) NSArray* wires;
@end
