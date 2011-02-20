//
//  HeadUnit.m
//  Mod-1
//
//  Created by Schell Scivally on 2/6/11.
//  Copyright 2011 Electrunique. All rights reserved.
//

#import "HeadUnit.h"


@implementation HeadUnit

#pragma mark -
#pragma mark Connections

- (NSArray*)connections {
	return [NSArray arrayWithObjects:[self input],nil];
}

#pragma mark -
#pragma mark Details

- (NSString*)description {
	return @"HeadUnit";
}

@end
