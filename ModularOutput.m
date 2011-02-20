//
//  ModularOutput.m
//  Mod-1
//
//  Created by Schell Scivally on 2/20/11.
//  Copyright 2011 Electrunique. All rights reserved.
//

#import "ModularOutput.h"
#import "ModularUnit.h"

@implementation ModularOutput
@synthesize remoteUnit;

- (id)initWithLocalUnit:(ModularUnit*)unit andName:(NSString*)cName {
	self = [super initWithType:ModularConnectionTypeOutput andName:cName];
	localUnit = unit;
	self.remoteUnit = nil;
	return self;
}

- (void)dealloc {
	localUnit = nil;
	self.remoteUnit = nil;
	[super dealloc];
}

- (ModularUnit*)localUnit {
	return localUnit;
}

#pragma mark -
#pragma mark Overrides

- (NSString*)description {
	return [NSString stringWithFormat:@"ModularOutput (output for %@)",[localUnit description]];
}

@end
