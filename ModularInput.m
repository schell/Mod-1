//
//  ModularInput.m
//  Mod-1
//
//  Created by Schell Scivally on 2/20/11.
//  Copyright 2011 Electrunique. All rights reserved.
//

#import "ModularInput.h"
#import "ModularOutput.h"
#import "ModularUnit.h"

@implementation ModularInput
@synthesize remoteUnit;

- (id)initWithLocalUnit:(ModularUnit*)unit andName:(NSString*)cName {
	self = [super initWithType:ModularConnectionTypeInput andName:cName];
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
	return [NSString stringWithFormat:@"ModularInput (input for %@)",[localUnit description]];
}

- (BOOL)connect:(ModularConnection *)connection {
	if ([connection type] == ModularConnectionTypeInput) {
		return NO;
	}
	
	ModularOutput* remoteConnection = (ModularOutput*)connection;
	if ([remoteConnection localUnit] == nil) {
		return NO;
	}
	
	self.remoteUnit = [remoteConnection localUnit];
	return YES;
}

- (BOOL)disconnect {
	if (self.remoteUnit == nil) {
		NSLog(@"%s %@: remote unit is not connected",__FUNCTION__,[self description]);
		// no-op
		return YES;
	}
	
	self.remoteUnit = nil;
	return YES;
}

@end
