//
//  ModularConnection.m
//  Mod-1
//
//  Created by Schell Scivally on 2/5/11.
//  Copyright 2011 Electrunique. All rights reserved.
//

#import "ModularConnection.h"
#import "ModularUnit.h"

@implementation ModularConnection
@synthesize description,inputUnit,outputUnit;

#pragma mark -
#pragma mark Lifecycle

- (id)init {
	self = [super init];
	_type = ModularConnectionTypeNone;
	_name = @"Unconfigured Connection";
	description = @"This is an unconfigured connection.";
	self.inputUnit = nil;
	self.outputUnit = nil;
	return self;
}

- (id)initWithType:(ModularConnectionType)cType andName:(NSString*)cName {
	self = [self init];
	_type = cType;
	_name = [cName retain];
	description = [NSString stringWithFormat:@"This is a configured %@ connection.",
				   _type==ModularConnectionTypeInput?@"input":
				   _type==ModularConnectionTypeOutput?@"output":@"dead end"];
	return self;
}

- (void)dealloc {
	if (_name != nil) {
		[_name release];
	}
	self.inputUnit = nil;
	self.outputUnit = nil;
	[super dealloc];
}

#pragma mark -
#pragma mark Functions to override

- (ModularConnectionType)type {
	return _type;
}

- (NSString*)name {
	return _name;
}

@end