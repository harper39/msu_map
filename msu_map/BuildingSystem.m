//
//  BuildingSystem.m
//  msu_map
//
//  Created by Minh Pham on 11/10/12.
//  Copyright (c) 2012 Minh Pham. All rights reserved.
//

#import "BuildingSystem.h"

// file name should not contain the extension (just the way xcode work)
// the default extension is txt
#define filename @"build_master"

// Manage the list of buildings
// Primary function is loading the building list
// Possibly handle the search
@implementation BuildingSystem {
    NSArray* buildingArray;
}

// Initialize the building list 
- (id) init
{
    // Get the path, then load the content
    NSString *path = [[NSBundle mainBundle] pathForResource: filename ofType:@"txt"];
    NSString *contents = [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];
    NSArray *lines = [contents componentsSeparatedByString:@"\n"];
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];

    for (NSString* line in lines) {
        if ([line length] < 5) break; // guard a against empty line
        Building *tempBuilding = [[Building alloc] init:line];
        [tempArray addObject:tempBuilding];
    }
    
    buildingArray = [[NSArray alloc] initWithArray:tempArray];
    //NSLog(filename, @"");
    
    tempArray = nil;
    return self;
}

// Return the list of buildings
- (NSArray*) getBuildings
{
    return buildingArray;
}

@end
