//
//  ModularConnection.m
//  Mod-1
//
//  Created by Schell Scivally on 2/5/11.
//  Copyright 2011 Electrunique. All rights reserved.
//

#import "ModularConnection.h"

@implementation ModularConnection

#pragma mark -
#pragma mark Lifecycle

- (id)init {
	self = [super init];
	_type = ModularConnectionTypeNone;
	_dataType = ModularConnectionDataTypeAudioSample;
	_name = @"Unconfigured Connection";
	return self;
}

- (id)initWithType:(ModularConnectionType)cType andName:(NSString*)cName {
	self = [self init];
	_type = cType;
	_name = [cName retain];
	return self;
}

- (void)dealloc {
	if (_name != nil) {
		[_name release];
	}
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

- (NSString*)description {
	return [NSString stringWithFormat:@"This is a configured %@ connection.",
			_type==ModularConnectionTypeInput?@"input":
			_type==ModularConnectionTypeOutput?@"output":@"dead end"];
}

- (BOOL)connect:(ModularConnection *)connection {
	NSLog(@"%s",__FUNCTION__);
	return NO;
}

- (BOOL)disconnect {
	NSLog(@"%s",__FUNCTION__);
	return NO;
}

@end