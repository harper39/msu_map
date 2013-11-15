//
//  msu_mapTests.m
//  msu_mapTests
//
//  Created by Minh Pham on 10/11/12.
//  Copyright (c) 2012 Minh Pham. All rights reserved.
//

#import "msu_mapTests.h"

#import "JSONParser.h"
#import "SegmentHandler.h"
#import "Segment.h"

@implementation msu_mapTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void) testQuery
{
    JSONParser *parse = [JSONParser alloc];
    SegmentHandler *segHandler = [parse getSegmentToDestination:@"016" :@42.72476731 :@-84.4662846956];
    if (segHandler) NSLog(@"Successful retrieve segments from server");
    else STFail(@"Unsuccessful query");
}

- (void) testGiveDirection
{
    CGPoint startPoint = CGPointMake(1, 0);
    CGPoint intersection = CGPointMake(0, 0);
    CGPoint endPoint = CGPointMake(-1, 1);
    SegmentHandler *segHandler = [SegmentHandler alloc];
    CGFloat bearing = [segHandler getBearingFrom:startPoint intersect:intersection to:endPoint];
    if (bearing != 225) STFail(@"Wrong bearing: %f compare to 225",bearing);
    NSNumber *clock = [segHandler getClockBearing:startPoint intersect:intersection to:endPoint];
    if (![clock isEqualToNumber:@10]) STFail(@"Wrong direction: %@ o'clock", clock);
    
    startPoint = CGPointMake(1, 0);
    intersection = CGPointMake(0, 0);
    endPoint = CGPointMake(1, 1);
    bearing = [segHandler getBearingFrom:startPoint intersect:intersection to:endPoint];
    if (bearing != 45) STFail(@"Wrong bearing: %f compare to 45",bearing);
    clock = [segHandler getClockBearing:startPoint intersect:intersection to:endPoint];
    if (![clock isEqualToNumber:@4]) STFail(@"Wrong direction: %@ o'clock", clock);
    
    startPoint = CGPointMake(0, 1);
    intersection = CGPointMake(0, 0);
    endPoint = CGPointMake(1, 1);
    bearing = [segHandler getBearingFrom:startPoint intersect:intersection to:endPoint];
    if (bearing != 315) STFail(@"Wrong bearing: %f compare to 315",bearing);
    clock = [segHandler getClockBearing:startPoint intersect:intersection to:endPoint];
    if (![clock isEqualToNumber:@7]) STFail(@"Wrong direction: %@ o'clock", clock);
}
@end
