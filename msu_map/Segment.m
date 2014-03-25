//
//  Segment.m
//  msu_map
//
//  Created by Pham Khac Minh on 10/5/13.
//  Copyright (c) 2013 Minh Pham. All rights reserved.
//

#import "Segment.h"
#import "SegmentHelper.h"

@implementation Segment {
    SegmentHelper* segHelper;
    NSNumber* pathLength;
    NSArray* pointsArray;
}

@synthesize type;
@synthesize name;
@synthesize bearingToNextSegment;

// Angle deviation small enough to consider merging (in degree)
const float MergeAngleThreshold = 15.0;

// init with all properties
- (id) initWithPath: (NSArray*) aPath
             length: (NSNumber*) aLength
               name: (NSString*) aName
               type: (NSString*) aType
{
    pointsArray = aPath;
    pathLength = aLength;
    name = aName;
    type = aType;
    bearingToNextSegment = 0.0;
    segHelper = [SegmentHelper alloc];
    
    return self;
}

-(id) initWithJSON: (NSDictionary*) json
{
    pathLength = [json objectForKey:@"LENGTH"];
    type = [json objectForKey:@"TYPE"];
    pointsArray = [json objectForKey:@"POINTS"];
    name = [json objectForKey:@"NAME"];
    bearingToNextSegment = 0.0;
    segHelper = [SegmentHelper alloc];
    
    return self;
}

// Compute the bearing to switch from one segment to another
- (CGFloat) getBearingToSegment:(Segment *)toSeg
{
    NSArray* fromPath = [self getPath];
    CGPoint fromEndPoint = CGPointMake([[fromPath objectAtIndex:fromPath.count-2] floatValue],[[fromPath lastObject] floatValue]);
    CGPoint fromSecondPoint = CGPointMake([[fromPath objectAtIndex:fromPath.count-4] floatValue],[[fromPath objectAtIndex:fromPath.count-3] floatValue]);
    
    NSArray* toPath = [toSeg getPath];
    CGPoint toEndPoint = CGPointMake([[toPath objectAtIndex:0] floatValue],[[toPath objectAtIndex:1] floatValue]);
    CGPoint toSecondPoint = CGPointMake([[toPath objectAtIndex:2] floatValue],[[toPath objectAtIndex:3] floatValue]);
    
    if (!CGPointEqualToPoint(fromEndPoint, toEndPoint)) return 0.0;
    else return [segHelper getBearingFrom:fromSecondPoint intersect:fromEndPoint to:toSecondPoint];
}

// Update bearingToNextSegment
// can be tricky and backward
- (void) updateBearingFromSegment:(Segment *)toSeg
{
    if (toSeg == nil) {
        self.bearingToNextSegment = 0;
        return;
    }
    self.bearingToNextSegment = 360 - [toSeg getBearingToSegment:self];
}

// Try to merge to segments together
// \return nil if not mergeable, a new segment from merging otherwise
-(Segment*) mergeWithSegment: (Segment*) aSeg
{
    // Array for type of segments that are mergeable
    NSArray* MergeableSegmentTypes = [NSArray arrayWithObjects:@"SIDEWALK", @"CROSSWALK", nil];
    
    if (aSeg == nil) return nil;
    CGFloat bearing = [self getBearingToSegment:aSeg];
    
    if (bearing >= (180 - MergeAngleThreshold) && bearing <= (180 + MergeAngleThreshold)) {
        Segment* mainSeg = nil; // main segment to get type and name from
        if ([MergeableSegmentTypes containsObject:[aSeg type]]) mainSeg = self;
        else if ([MergeableSegmentTypes containsObject:[self type]] ) mainSeg = aSeg;
        else return nil;
        
        NSString* newType = [NSString stringWithString:[mainSeg type]];
        NSString* newName = [NSString stringWithString:[mainSeg name]];
        NSNumber* newLength = [[NSNumber alloc] initWithDouble:[aSeg getLength] + [self getLength] ];
        NSMutableArray* newPath = [[NSMutableArray alloc] init];
        
        [newPath addObjectsFromArray:[self getPath]];
        [newPath addObjectsFromArray:[[aSeg getPath] subarrayWithRange:NSMakeRange(2, [aSeg getPath].count-2)]];
        
        return [[Segment alloc] initWithPath:newPath length:newLength name:newName type:newType];
    }
    else
    {
        return nil;
    }
}

// Determine whether a point is on the segment
// \return index of the pointsArray found where the point is closest
// -1 if not found
- (int) findIndexOfLat: (NSNumber*) latitude
                  long: (NSNumber*) longitude
{
    if ([segHelper isTooCloseLat:[latitude doubleValue] long:[longitude doubleValue]
                          andLat:[[pointsArray objectAtIndex:1] doubleValue] long:[[pointsArray objectAtIndex:0] doubleValue]])
        return 0;
    
    int i = [pointsArray count] - 1;
    CGPoint midPoint = CGPointMake([latitude floatValue], [longitude floatValue]);
    CGPoint prevPoint = CGPointMake([[pointsArray objectAtIndex:i] floatValue], [[pointsArray objectAtIndex:i-1] floatValue]);
    CGPoint currPoint;
    i -= 2;
    
    // Loop through the pointsArray
    while (i >= 1)
    {
        currPoint = CGPointMake([[pointsArray objectAtIndex:i] floatValue], [[pointsArray objectAtIndex:i-1] floatValue]);
        // if the point is in between a prevPoint and currPoint
        if ([segHelper checkMidPoint:midPoint between:prevPoint and:currPoint]) break;
        i -= 2;
        prevPoint = currPoint;
    }
    return i;
}

// Return an array of lat long coordinates
- (NSArray*) getPath
{
    return pointsArray;
}


// Return number of points in the path
- (int) pathCount
{
    return [pointsArray count];
}

// Return the total length of this segment
- (double) getLength
{
    return [pathLength doubleValue];
}


// Return the path length till index
- (double) getLengthTillIndex: (int) i
{
    return [segHelper computePathDistance:[self getPathTillIndex:i]];
}

// Return an array of lat long coordinates
- (NSArray*) getPathTillIndex:(int)i
{
    if (i >= [pointsArray count]) {
        NSLog(@"Index out of range: %d", i);
        return nil;
    }
    if (i % 2 == 0) {
        NSLog(@"Index should not be even %d",i );
        return nil;
    }
    return [pointsArray subarrayWithRange:NSMakeRange(0, i+1)];
}

@end
