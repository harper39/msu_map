//
//  SegmentHandler.m
//  msu_map
//
//  Created by Pham Khac Minh on 10/5/13.
//  Copyright (c) 2013 Minh Pham. All rights reserved.
//

#import "SegmentHandler.h"

@implementation SegmentHandler { 
    NSArray* segmentArray;
    NSNumber* pathLength;
}

// Angle deviation small enough to consider merging
const double MergeAngleThreshold = 15.0;

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
    
    pathLength = [NSNumber numberWithFloat:[[content objectForKey:@"GEOM_LENGTH"] floatValue]];
    return self;
}

// Get path from all segments
- (NSArray*) getPath
{
    NSMutableArray* path = [[NSMutableArray alloc] init];
    for(int i=0; i<[segmentArray count]; i++)
    {
        [path addObjectsFromArray:[[segmentArray objectAtIndex:i] pointsArray]];
    }
    return path;
}

// Return the segment array
-(NSArray*) getAllSegments
{
    return segmentArray;
}

-(NSUInteger*) count
{
    return [segmentArray count];
}

-(NSNumber*) getPathLength
{
    return pathLength;
}

// Compute the bearing
- (CGFloat) getBearingFrom:(CGPoint)startPoint intersect:(CGPoint)intersection to:(CGPoint)endPoint
{
    // compute bearing relative to start point
    CGPoint relativeStartPoint = CGPointMake(startPoint.x - intersection.x, startPoint.y - intersection.y);
    // check if the start point and intersection are the same
    if (relativeStartPoint.x == 0 && relativeStartPoint.y == 0) return NZERO;
    float bearingStart = atan2f(relativeStartPoint.y, relativeStartPoint.x);
    
    // Compute bearing relate to end point
    CGPoint relativeEndPoint = CGPointMake(endPoint.x - intersection.x, endPoint.y - intersection.y);
    // check if the start point and intersection are the same
    if (relativeEndPoint.x == 0 && relativeEndPoint.y == 0) return NZERO;
    float bearingEnd = atan2f(relativeEndPoint.y, relativeEndPoint.x);

    
    float bearingRadian = bearingEnd - bearingStart;
    float bearingDegrees = bearingRadian * 180 / M_PI;
    bearingDegrees = (bearingDegrees > 0.0 ? bearingDegrees : (360.0 + bearingDegrees)); // correct discontinuity
    return bearingDegrees;
}

// Compute the bearing to switch from one segment to another
- (CGFloat) getBearingFromSegment: (Segment*) fromSeg to: (Segment*)toSeg
{
    NSArray* fromPath = [fromSeg pointsArray];
    CGPoint fromEndPoint = CGPointMake([[fromPath objectAtIndex:fromPath.count-2] floatValue],[[fromPath lastObject] floatValue]);
    CGPoint fromSecondPoint = CGPointMake([[fromPath objectAtIndex:fromPath.count-4] floatValue],[[fromPath objectAtIndex:fromPath.count-3] floatValue]);
    
    NSArray* toPath = [toSeg pointsArray];
    CGPoint toEndPoint = CGPointMake([[toPath objectAtIndex:0] floatValue],[[toPath objectAtIndex:1] floatValue]);
    CGPoint toSecondPoint = CGPointMake([[toPath objectAtIndex:2] floatValue],[[toPath objectAtIndex:3] floatValue]);
    
    if (!CGPointEqualToPoint(fromEndPoint, toEndPoint)) return NZERO;
    else return [self getBearingFrom:fromSecondPoint intersect:fromEndPoint to:toSecondPoint];
}

// Compute the bearing to switch from one segment to another
// \param fromSegInx the index of the 'from' segment
// \param toSegInx the index of the 'to segment
- (CGFloat) getBearingFromSegmentIndex: (int) fromSegInx to: (int)toSegInx
{
    return [self getBearingFromSegment:[segmentArray objectAtIndex: fromSegInx] to:[segmentArray objectAtIndex:toSegInx]];
}

// Compute bearing and change it to clock format
- (NSNumber*) getClockBearing:(CGPoint)from intersect:(CGPoint)mid to:(CGPoint)to
{
    float bearingDegrees = [self getBearingFrom:from intersect:mid to:to];
    // intersection is the same as start or end point
    if (bearingDegrees == NZERO) return NULL;
    
    int clock = (int) (bearingDegrees + 15) / 30;
    clock = 12 - (clock + 6) % 12;
    return [NSNumber numberWithInt:clock];
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
        mergeSeg = [self mergeSegment:prevSeg with:currSeg]; // try to merge the two segments
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

// Try to merge to segments together
// \return nil if not mergeable, a new segment from merging otherwise
-(Segment*) mergeSegment: (Segment*) seg1 with:(Segment*) seg2
{
    // Array for type of segments that are mergeable
    NSArray* MergeableSegmentTypes = [NSArray arrayWithObjects:@"SIDEWALK", @"CROSSWALK", nil];
    
    if (seg1 == nil || seg2 == nil) return nil;
    CGFloat bearing = [self getBearingFromSegment:seg1 to:seg2];
    
    if (bearing >= (180 - MergeAngleThreshold) && bearing <= (180 + MergeAngleThreshold)) {
        Segment* mainSeg = nil; // main segment to get type and name from
        if ([MergeableSegmentTypes containsObject:[seg1 type]]) mainSeg = seg2;
        else if ([MergeableSegmentTypes containsObject:[seg2 type]] ) mainSeg = seg1;
        else return nil;
        
        NSString* type = [NSString stringWithString:[mainSeg type]];
        NSString* name = [NSString stringWithString:[mainSeg name]];
        NSNumber* length = [NSNumber numberWithFloat:([[seg1 length] floatValue] + [[seg2 length] floatValue])];
        NSMutableArray* path = [[NSMutableArray alloc] init];
        
        [path addObjectsFromArray:[seg1 pointsArray]];
        [path addObjectsFromArray:[[seg2 pointsArray] subarrayWithRange:NSMakeRange(2, [seg2 pointsArray].count-2)]];
        
        return [[Segment alloc] initWithPath:path length:length name:name type:type];
    }
    else
    {
        return nil;
    }
}

@end
