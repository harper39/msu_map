//
//  SegmentHandler.m
//  msu_map
//
//  Created by Pham Khac Minh on 10/5/13.
//  Copyright (c) 2013 Minh Pham. All rights reserved.
//

#import "SegmentHandler.h"

@implementation SegmentHandler { 
    NSArray* segmentArray; // array contains all segments
    NSArray* pathArray; // array contains all path
}

@synthesize pathLength;
@synthesize dirGiver;

- (id) initWithContent:(NSDictionary*)content
{
    NSArray* geometry = [content objectForKey:@"GEOMETRY"];
    NSMutableArray* segments = [[NSMutableArray alloc] initWithCapacity:[geometry count]];
    for(int i=0; i<[geometry count]; i++)
    {
        Segment* tempSeg = [[Segment alloc] initWithJSON:[geometry objectAtIndex:i]];
        [segments addObject:tempSeg];
    }
    segmentArray = segments;
    pathLength = [content objectForKey:@"GEOM_LENGTH"];
    
    [self trimSegment];
    [self computeSegmentsBearing];
    dirGiver = [[DirectionGiver alloc] initWithSegHandler:self];
    
    NSMutableArray* path = [[NSMutableArray alloc] init];
    for(int i=0; i < [segmentArray count]; i++)
    {
        [path addObjectsFromArray:[[segmentArray objectAtIndex:i] getPath]];
    }
    pathArray = path;
    
    return self;
}

// Get current path from segments and current location
- (NSArray*) getPathWithoutCurrentLocation
{
    int currSegInx = [dirGiver getCurrSegInx];
    int currPointInx = [dirGiver getCurrPointInx];
    int pathInx = 0; // index of last point in path array
    
    for(int i=0; i < currSegInx; i++)
    {
        pathInx += [[segmentArray objectAtIndex:i] pathCount];
    }
    
    if (currSegInx >= 0) {
        pathInx += currPointInx;
    }
    
    assert(pathInx % 2 == 1);
    if (pathInx > pathArray.count-3) {
        NSLog(@"I skewed up: Path index too big: %d", pathInx);
        pathInx = pathArray.count-3;
    }
    return [pathArray subarrayWithRange:NSMakeRange(0, pathInx+3)];
}

// Return the segment array
-(NSArray*) getAllSegments
{
    return segmentArray;
}

// Number of segment
-(NSUInteger*) count
{
    return [segmentArray count];
}

// Get the length of the path till current location
// length is in feet
- (double) getCurrentPathLength;
{
    int currSegInx = [dirGiver getCurrSegInx];
    int currPointInx = [dirGiver getCurrPointInx];
    
    double currLength = 0;
    for(int i=0; i<= currSegInx - 1; i++) {
        currLength += [[segmentArray objectAtIndex:i] getLength];
    }
    if (currSegInx >= 0) currLength += [[segmentArray objectAtIndex:currSegInx] getLengthTillIndex:currPointInx];
    return currLength;
}

// Compute the bearing to switch from one segment to another
// \param fromSegInx the index of the 'from' segment
// \param toSegInx the index of the 'to segment
- (CGFloat) getBearingFromSegmentIndex: (int) fromSegInx to: (int)toSegInx
{
    return [[segmentArray objectAtIndex: fromSegInx] getBearingToSegment:[segmentArray objectAtIndex:toSegInx]];
}

// Collapse small segments together
-(void) trimSegment
{
    NSMutableArray* newSegArray = [[NSMutableArray alloc] init];
    Segment* prevSeg = [segmentArray objectAtIndex:0];
    Segment* currSeg = nil;
    Segment* mergeSeg = nil;
    
    for(int i=1; i<[segmentArray count]; i++)
    {
        currSeg = [segmentArray objectAtIndex:i];
        mergeSeg = [prevSeg mergeWithSegment:currSeg]; // try to merge the two segments
        if (mergeSeg == nil)
        {
            // cannot merge
            [newSegArray addObject:prevSeg];
            prevSeg = currSeg;
        }
        else
        {
            // can merge
            prevSeg = mergeSeg;
        }
    }
    
    [newSegArray addObject:prevSeg];
    segmentArray = newSegArray;
}

// Compute bearing for each segment to the next one
// used for DirectionGiver
- (void) computeSegmentsBearing
{
    for(int i=1; i<[segmentArray count]; i++)
    {
        [[segmentArray objectAtIndex:i] updateBearingFromSegment:[segmentArray objectAtIndex:i-1]];
    }
    [[segmentArray firstObject] updateBearingFromSegment:nil];
}

@end
