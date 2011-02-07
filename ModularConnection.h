//
//  ModularConnection.h
//  Mod-1
//
//  Created by Schell Scivally on 2/5/11.
//  Copyright 2011 Electunique. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ModularUnit;

typedef enum {
	ModularConnectionTypeInput,
	ModularConnectionTypeOutput,
	ModularConnectionTypeNone
} ModularConnectionType;

@interface ModularConnection : NSObject {
	ModularConnectionType _type;
	NSString* _name;
}
- (id)initWithType:(ModularConnectionType)cType andName:(NSString*)cName;
- (ModularConnectionType)type;
- (NSString*)name;
@property (readwrite,retain) ModularUnit* inputUnit;
@property (readwrite,retain) ModularUnit* outputUnit;
@end
