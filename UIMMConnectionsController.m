    //
//  UIMMConnectionsController.m
//  Mod-1
//
//  Created by Schell Scivally on 2/13/11.
//  Copyright 2011 Electrunique. All rights reserved.
//

#import "UIMMConnectionsController.h"
#import "ModularConnection.h"
#import "ModularInput.h"
#import "ModularOutput.h"
#import "UIConnectionView.h"
#import "UISocketView.h"
#import "UIWiresView.h"

@implementation UIMMConnectionsController
@synthesize connections;

static NSMutableSet* _allControllers_ = nil;
static NSMutableArray* _wiredConnectionViews_ = nil;

- (id)init {
	self = [super init];
	if (self != nil) {
		connections = nil;
		_headerView = nil;
		_inputViews = nil;
		_outputViews = nil;
		if (_allControllers_ == nil) {
			_allControllers_ = [[NSMutableSet alloc] init];
		}
		[_allControllers_ addObject:self];
	}
	return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)destroy {
	[_allControllers_ removeObject:self];
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark -
#pragma mark Shared
+ (UIWiresView*)sharedWireDisplayView {
	static UIWiresView* wireView = nil;
	if (wireView == nil) {
		wireView = [[UIWiresView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
		wireView.userInteractionEnabled = NO;
		wireView.backgroundColor = [UIColor clearColor];
	}
	return wireView;
}

#pragma mark -
#pragma mark Connections

- (NSSet*)allConnectionViews {
	NSMutableSet* connectionViews = [NSMutableSet setWithArray:_outputViews];
	[connectionViews unionSet:[NSMutableSet setWithArray:_inputViews]];
	return connectionViews;
}

- (NSSet*)inputViews {
	return [NSSet setWithArray:_inputViews];
}

- (NSSet*)outputViews {
	return [NSSet setWithArray:_outputViews];
}

+ (NSArray*)wiredSocketPairs {
	NSMutableArray* socketPairs = [NSMutableArray array];
	for (UIConnectionView* connectionView in _wiredConnectionViews_) {
		CGPoint start = [[UIMMConnectionsController sharedWireDisplayView] 
						 convertPoint:connectionView.socketView.center 
						 fromView:connectionView.socketView.superview];
		CGPoint end = [[UIMMConnectionsController sharedWireDisplayView] 
						 convertPoint:connectionView.wiredConnectionView.socketView.center 
						 fromView:connectionView.wiredConnectionView.socketView.superview];
		[socketPairs addObject:[NSValue valueWithCGPoint:start]];
		[socketPairs addObject:[NSValue valueWithCGPoint:end]];
	}
	return socketPairs;
}

- (UIConnectionView*)setTemporaryWireAndGetConnectionViewAtPoint:(CGPoint)point {
	UIConnectionView* selectedConnectionView = nil;
	BOOL snapped = NO;
	for (UIMMConnectionsController* controller in _allControllers_) {
		if (controller == self) {
			continue;
		}
		// broad phase - is the wire end point inside another controller's view frame?
		CGRect controllerViewFrame = [controller.view convertRect:controller.view.frame toView:[UIMMConnectionsController sharedWireDisplayView]];
		if (CGRectContainsPoint(controllerViewFrame, point)) {
			NSSet* connectionViews = _connectionViewBeingWired.connectionType == ModularConnectionTypeInput ? [controller outputViews] : [controller inputViews];
			for (UIConnectionView* connectionView in connectionViews) {
				// exact phase - is the wire end point inside a valid connection's view frame?
				CGRect connectionViewFrame = [connectionView convertRect:connectionView.bounds toView:[UIMMConnectionsController sharedWireDisplayView]];
				if (CGRectContainsPoint(connectionViewFrame, point)) {
					snapped = YES;
					_temporaryWireEnd = [[UIMMConnectionsController sharedWireDisplayView] convertPoint:connectionView.socketView.center fromView:connectionView.socketView.superview];
					selectedConnectionView = connectionView;
					break;
				}
			}
		}
		if (snapped) {
			break;
		}
	}
	if (!snapped) {
		_temporaryWireEnd = point;
	}
	return selectedConnectionView;
}

+ (void)unwireConnectionViews:(NSArray*)connectionViews {
	for (UIConnectionView* connectionView in connectionViews) {
		// unwire the audio
		ModularConnection* connection = [connectionView.controller.connections objectAtIndex:connectionView.index];
		switch ([connection type]) {
			case ModularConnectionTypeInput:
				if (![connection disconnect]) {
					[NSException raise:@"could not disconnect connection" format:@"%@",connection];
				}
				break;
			case ModularConnectionTypeOutput: {
				if (connectionView.wiredConnectionView == nil) {
					NSLog(@"%s connection is not wired...",__FUNCTION__);
					break;
				}
				connection = [connectionView.wiredConnectionView.controller.connections objectAtIndex:connectionView.wiredConnectionView.index];
				if (![connection disconnect]) {
					[NSException raise:@"could not disconnect connection" format:@"%@",connection];
				}
				break;
			}
			default:
				break;
		}
		
		// unwire the view
		[_wiredConnectionViews_ removeObject:connectionView];
		if (connectionView.wiredConnectionView != nil) {
			[_wiredConnectionViews_ removeObject:connectionView.wiredConnectionView];
		}
		connectionView.wiredConnectionView.wiredConnectionView = nil;
		connectionView.wiredConnectionView = nil;
	}
	[UIMMConnectionsController sharedWireDisplayView].wires = [self wiredSocketPairs];
	[[UIMMConnectionsController sharedWireDisplayView] setNeedsDisplay];
}

+ (void)wireConnectionView:(UIConnectionView *)connectionView to:(UIConnectionView *)connectionViewBeingWired {
	if (_wiredConnectionViews_ == nil) {
		_wiredConnectionViews_ = [[NSMutableSet alloc] init];
	}
	NSLog(@"%s%i",__FUNCTION__,[_wiredConnectionViews_ count]);
	if ([_wiredConnectionViews_ containsObject:connectionView]) {
		NSLog(@"	connectionView exists");
		if (connectionView.wiredConnectionView == connectionViewBeingWired) {
			NSLog(@"	connection has already been made, abort");
			return;
		} else {
			NSLog(@"	connection is new but an existing connection must be broken first");
			[UIMMConnectionsController unwireConnectionViews:[NSArray arrayWithObjects:connectionView,connectionViewBeingWired,nil]];
		}
	}
	if ([_wiredConnectionViews_ containsObject:connectionViewBeingWired]){
		NSLog(@"	connectionViewBeingWired exists");
		if (connectionView.wiredConnectionView == connectionViewBeingWired) {
			NSLog(@"	connection has already been made, abort");
			return;
		} else {
			NSLog(@"	connection is new but an existing connection must be broken first");
			[UIMMConnectionsController unwireConnectionViews:[NSArray arrayWithObjects:connectionViewBeingWired,connectionView,nil]];
		}
	}

	connectionView.wiredConnectionView = connectionViewBeingWired;
	connectionViewBeingWired.wiredConnectionView = connectionView;
	[_wiredConnectionViews_ addObject:connectionView];
	[UIMMConnectionsController sharedWireDisplayView].wires = [self wiredSocketPairs];
	[[UIMMConnectionsController sharedWireDisplayView] setNeedsDisplay];
	// wire up the audio
	ModularConnection* connectionStart = [connectionView.controller.connections objectAtIndex:connectionView.index];
	ModularConnection* connectionEnd = [connectionViewBeingWired.controller.connections objectAtIndex:connectionViewBeingWired.index];
	ModularInput* input = (ModularInput*) ([connectionStart type] == ModularConnectionTypeInput ? connectionStart : connectionEnd);
	ModularOutput* output = (ModularOutput*) ([connectionStart type] == ModularConnectionTypeOutput ? connectionStart : connectionEnd);
	if (![input connect:output]) {
		[NSException raise:@"could not connect connections" format:@"%@ <- %@",input,output];
	}
}

#pragma mark -
#pragma mark View Layout

- (CGRect)frameForHeader {
	return CGRectMake(0, 0, self.view.frame.size.width, 40);
}

#pragma mark -
#pragma mark View Events

- (void)viewWillAppear:(BOOL)animated {
}

#pragma mark -
#pragma mark View Creation

- (UIColor*)connectionsColor {
	return [UIColor whiteColor];
}

- (UIConnectionView*)connectionViewAtIndex:(UInt32)index onLeft:(BOOL)left {
	CGRect headerViewFrame = [self frameForHeader];
	UIConnectionView* connectionView = [[[UIConnectionView alloc] initWithFrame:CGRectMake(left?0:headerViewFrame.size.width/2, headerViewFrame.size.height * (index + 1), headerViewFrame.size.width/2, headerViewFrame.size.height)] autorelease];
	connectionView.controller = self;
	connectionView.backgroundColor = [self connectionsColor];
	
	NSArray* connectionSet = left?_outputConnections:_inputConnections;
	ModularConnection* connection = [connectionSet objectAtIndex:index];
	if (connection == nil) {
		connection = [[[ModularConnection alloc] init] autorelease];
	}
	
	CGFloat space = 10.0;
	CGFloat radius = 10.0;
	
	connectionView.label = [[UILabel alloc] initWithFrame:CGRectMake(left?radius*2+space:0, 0, connectionView.frame.size.width - radius*2 - space*2, connectionView.frame.size.height)];
	connectionView.label.text = [NSString stringWithFormat:@"   %@",[connection name]];
	connectionView.label.font = [UIFont systemFontOfSize:15.0];
	connectionView.label.backgroundColor = [UIColor clearColor];
	connectionView.label.textColor = [UIColor darkGrayColor];
	connectionView.label.textAlignment = left?UITextAlignmentRight:UITextAlignmentLeft;
	[connectionView addSubview:connectionView.label];
	
	connectionView.socketView = [[[UISocketView alloc] initWithFrame:CGRectMake(left?space:connectionView.frame.size.width - radius*2 - 10, connectionView.frame.size.height/2 - radius, radius*2, radius*2)] autorelease];
	[connectionView addSubview:connectionView.socketView];
	return connectionView;
}

- (UIConnectionView*)inputViewAtIndex:(UInt32)index {
	if (_inputViews != nil && [_inputViews count] > index) {
		return [_inputViews objectAtIndex:index];
	}
	
	return [self connectionViewAtIndex:index onLeft:NO];
}

- (UIConnectionView*)outputViewAtIndex:(UInt32)index {
	if (_outputViews != nil && [_outputViews count] > index) {
		return [_outputViews objectAtIndex:index];
	}
	
	return [self connectionViewAtIndex:index onLeft:YES];
}

- (void)createView {
	if (_headerView == nil) {
		_headerView = [[UIView alloc] initWithFrame:[self frameForHeader]];
		
		UILabel* outputLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, _headerView.frame.size.width/2, _headerView.frame.size.height)];
		outputLabel.text = @"  Output";
		outputLabel.font = [UIFont boldSystemFontOfSize:20.0];
		outputLabel.backgroundColor = [self connectionsColor];
		outputLabel.textColor = [UIColor darkGrayColor];
		outputLabel.textAlignment = UITextAlignmentLeft;
		[_headerView addSubview:outputLabel];
		
		UILabel* inputLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headerView.frame.size.width/2, 0, _headerView.frame.size.width/2, _headerView.frame.size.height)];
		inputLabel.text = @"Input  ";
		inputLabel.font = [UIFont boldSystemFontOfSize:20.0];
		inputLabel.backgroundColor = outputLabel.backgroundColor;
		inputLabel.textColor = outputLabel.textColor;
		inputLabel.textAlignment = UITextAlignmentRight;
		[_headerView addSubview:inputLabel];
		
		_inputViews = [[NSMutableArray array] retain];
		_outputViews = [[NSMutableArray array] retain];
		_inputConnections = [[NSMutableArray array] retain];
		_outputConnections = [[NSMutableArray array] retain];
		
		for (UInt32 i = 0; i < [connections count]; i++) {
			ModularConnection* connection = [self.connections objectAtIndex:i];
			UIConnectionView* connectionView = nil;
			
			switch (connection.type) {
				case ModularConnectionTypeInput:
					[_inputConnections addObject:connection];
					connectionView = [self inputViewAtIndex:[_inputConnections count]-1];
					connectionView.connectionType = connection.type;
					[_inputViews addObject:connectionView];
					break;
				case ModularConnectionTypeOutput:
					[_outputConnections addObject:connection];
					connectionView = [self outputViewAtIndex:[_outputConnections count]-1];
					connectionView.connectionType = connection.type;
					[_outputViews addObject:connectionView];
					break;
				case ModularConnectionTypeNone:
				default:
					break;
			}
			if (connectionView != nil) {
				connectionView.index = i;
				[self.view addSubview:connectionView];
			}
		}
		
		[self.view addSubview:_headerView];
	}
}

#pragma mark -
#pragma mark User Interaction

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	CGPoint wireLoc = [(UITouch*)[touches anyObject] locationInView:[UIMMConnectionsController sharedWireDisplayView]];
	NSSet* connectionViews = [self allConnectionViews];
	_connectionViewBeingWired = nil;
	for (UIConnectionView* connectionView in connectionViews) {
		if (connectionView.connectionType == ModularConnectionTypeNone) {
			continue;
		}
		CGRect connectionViewFrame = [[UIMMConnectionsController sharedWireDisplayView] convertRect:connectionView.frame fromView:connectionView.superview];
		if (CGRectContainsPoint(connectionViewFrame, wireLoc)) {
			[UIMMConnectionsController unwireConnectionViews:[NSArray arrayWithObject:connectionView]];
			_connectionViewBeingWired = connectionView;
			UISocketView* socketView = connectionView.socketView;
			_temporaryWireStart = [[UIMMConnectionsController sharedWireDisplayView] convertPoint:socketView.center fromView:socketView.superview];
			_temporaryWireEnd = wireLoc;
			[[UIMMConnectionsController sharedWireDisplayView] drawTemporaryWireWithStart:_temporaryWireStart andEnd:_temporaryWireEnd];
			break;
		}
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	if (_connectionViewBeingWired != nil) {
		CGPoint wireLoc = [(UITouch*)[touches anyObject] locationInView:[UIMMConnectionsController sharedWireDisplayView]];
		[self setTemporaryWireAndGetConnectionViewAtPoint:wireLoc];
		[[UIMMConnectionsController sharedWireDisplayView] drawTemporaryWireWithStart:_temporaryWireStart andEnd:_temporaryWireEnd];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if (_connectionViewBeingWired != nil) {
		CGPoint wireLoc = [(UITouch*)[touches anyObject] locationInView:[UIMMConnectionsController sharedWireDisplayView]];
		UIConnectionView* connectionView = [self setTemporaryWireAndGetConnectionViewAtPoint:wireLoc];
		if (connectionView != nil) {
			[UIMMConnectionsController wireConnectionView:connectionView to:_connectionViewBeingWired];
		}
		[[UIMMConnectionsController sharedWireDisplayView] setNeedsDisplay];
	}
}
@end
	