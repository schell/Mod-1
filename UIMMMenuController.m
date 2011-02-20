//
//  UIMMMenuController.m
//  Mod-1
//
//  Created by Schell Scivally on 2/14/11.
//  Copyright 2011 Electrunique. All rights reserved.
//

#import "UIMMMenuController.h"
#import "UIMMSineWaveController.h"
#import "UIMMSquareWaveController.h"
#import "UIMMWhiteNoiseController.h"
#import "UIMMGainController.h"
#import "NoiseGeneratorUnit.h"
#import "SineWaveGeneratorUnit.h"
#import "SquareWaveGeneratorUnit.h"
#import "NoiseGeneratorUnit.h"
#import "GainUnit.h"

@implementation UIMMMenuController
@synthesize unitSelectedBlock;

#pragma mark -
#pragma mark Initialization


- (id)init {
    self = [super init];
    if (self) {
		_menuTableView = nil;
		unitSelectedBlock = nil;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark -
#pragma mark View Creation

- (UIView*)viewForContentView {
	if (_menuTableView == nil) {
		_menuTableView = [[UITableView alloc] initWithFrame:[self frameForContentView]];
		_menuTableView.backgroundColor = [UIColor whiteColor];
		_menuTableView.delegate = self;
		_menuTableView.dataSource = self;
	}
	return _menuTableView;
}

- (NSString*)stringForLabelTitle {
	return @"Creation Menu";
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//	return [NSArray arrayWithObjects:@"Generators",@"Filters",@"Accumulators",@"Controllers",nil];
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    switch (section) {
		case 0:
			return 3;
		case 1:
			return 1;
		case 2:
			return 0;
		case 3:
			return 0;
		default:
			break;
	}
	return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return @"Generators";
		case 1:
			return @"Filters";
		case 2:
			return @"Accumulators";
		case 3:
			return @"Controllers";
		default:
			return @"Other";
	}
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	cell.textLabel.textColor = [UIColor darkGrayColor];
	cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
	cell.selectionStyle = UITableViewCellSelectionStyleGray;
	
	switch ([indexPath section]) {
		case 0:
			switch ([indexPath row]) {
				case 0:
					cell.textLabel.text = @"Sine Wave";
					break;
				case 1:
					cell.textLabel.text = @"Square Wave";
					break;
					
				case 2:
					cell.textLabel.text = @"White Noise";
					break;
				default:
					break;
			}
			break;
		case 1:
			switch ([indexPath row]) {
				case 0:
					cell.textLabel.text = @"Gain";
					break;
				default:
					break;
			}
			break;
		case 2:
			break;
		case 3:
			break;
	}
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIMMUnitController* unitController = nil;
	
	switch ([indexPath section]) {
		case 0: // Generators
			switch ([indexPath row]) {
				case 0: // sine
					unitController = [[[UIMMSineWaveController alloc] init] autorelease];
					unitController.unit = [[[SineWaveGeneratorUnit alloc] init] autorelease];
					break;
				case 1: // square
					unitController = [[[UIMMSquareWaveController alloc] init] autorelease];
					unitController.unit = [[[SquareWaveGeneratorUnit alloc] init] autorelease];
					break;
				case 2: // noise
					unitController = [[[UIMMWhiteNoiseController alloc] init] autorelease];
					unitController.unit = [[[NoiseGeneratorUnit alloc] init] autorelease];
					break;
				default:
					break;
			}
			break;
		case 1:
			switch ([indexPath row]) {
				case 0: // gain
					unitController = [[[UIMMGainController alloc] init] autorelease];
					unitController.unit = [[[GainUnit alloc] init] autorelease];
					break;
				default:
					break;
			}
			break;
		case 2:
			break;
		case 3:
			break;
	}
	
	if (unitController != nil && unitSelectedBlock != nil) {
		unitSelectedBlock(unitController);
	}
}

@end

