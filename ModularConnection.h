//
//  ModularConnection.h
//  Mod-1
//
//  Created by Schell Scivally on 2/5/11.
//  Copyright 2011 Electunique. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	ModularConnectionTypeInput,
	ModularConnectionTypeOutput,
	ModularConnectionTypeNone
} ModularConnectionType;

typedef enum {
	ModularConnectionDataTypeAudioSample
} ModularConnectionDataType;

@interface ModularConnection : NSObject {
	@protected
	ModularConnectionType _type;
	ModularConnectionDataType _dataType;
	NSString* _name;
}
- (id)initWithType:(ModularConnectionType)cType andName:(NSString*)cName;
- (ModularConnectionType)type;
- (NSString*)name;
- (BOOL)connect:(ModularConnection*)connection;
- (BOOL)disconnect;
@end
