//
//  JSONParser.m
//  msu_map
//
//  Created by Minh Pham on 11/10/12.
//  Copyright (c) 2012 Minh Pham. All rights reserved.
//


#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define baseURL @"https://dev.gis.msu.edu/FlexData/wayfinding?QUERY="

#import "JSONParser.h"

// Add methods to NSDictionary
// -----------------------------------------------
@interface NSDictionary(JSONCategories)
+(NSDictionary*)dictionaryWithContentsOfJSONURLString:
(NSString*)urlAddress;
-(NSData*)toJSON;
@end

@implementation NSDictionary(JSONCategories)

+ (NSDictionary*)dictionaryWithContentsOfJSONURLString:
(NSString*)urlAddress
{
    NSData* data = [NSData dataWithContentsOfURL:
                    [NSURL URLWithString: urlAddress] ];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data
                                                options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}

- (NSData*)toJSON
{
    NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:self
                                                options:kNilOptions
                                                  error:&error];
    if (error != nil) return nil;
    return result;
}
@end
// -----------------------------------------------

@implementation JSONParser


- (NSData*)appendJSONDictionary:(NSDictionary*)jsonDict
                          toURL:(NSString*)url
{
    NSData* jsonData = [jsonDict toJSON];
    
    NSString* jsonString = [[NSString alloc]initWithData:jsonData
                                                encoding:NSUTF8StringEncoding];
    
    NSString* completeURL = [url stringByAppendingString:jsonString];
    NSString* escapedUrlString = [completeURL stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding];
    NSURL* escapedUrl = [NSURL URLWithString:escapedUrlString];
    
    //    NSData *data = [NSData dataWithContentsOfURL: escapedUrl];
    return [NSData dataWithContentsOfURL: escapedUrl];
}

- (NSDictionary*)fetchedData:(NSData *)responseData
{
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          options:kNilOptions
                          error:&error];
    
    //    // Check if the query was successful
    //    if ([[json objectForKey:@"STATUS"] isEqualToString:@"SUCCESS"]) {
    //        NSLog(@"status: %@", [json objectForKey:@"STATUS"]);
    //        _humanReadable.text = [json objectForKey:@"STATUS"];
    //    }
    //    else {
    //    }
    
    NSDictionary* content = [json objectForKey:@"CONTENT"];
    return content;
}

- (NSNumber*)getBuildingID:(NSString*)buildingName
{
    // Construct the query to get the destination building's id
    NSDictionary* query = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"NAMESEARCH", @"QUERYTYPE",
                           [NSDictionary dictionaryWithObjectsAndKeys:
                            buildingName,  @"SEARCHTERM", nil],
                           @"ARGUMENTS", nil];
    
    NSData* data = [self appendJSONDictionary:query toURL:baseURL];
    //    NSLog(@"data: %@", data);
    
    NSDictionary* content = [self fetchedData:data];  // TODO: should be executed in a seperate thread
    
    NSNumber* buildingID = [[[content objectForKey:@"DATA"] objectAtIndex:0] objectForKey:@"OBJECT_ID"];
    return buildingID;
    //    return [NSNumber numberWithInt:4];
}

- (NSArray*)getPathToDestination:(NSString*)buildingID
                    :(NSNumber*)latitude
                    :(NSNumber*)longitude
{
    // Construct the json query
    NSDictionary* query = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"FINDPATH", @"QUERYTYPE",
                           [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             latitude,  @"NORTHING",
                             longitude, @"EASTING",
                             @"LOCATION", @"TYPE", nil], @"FROM",
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             @"BUILDING",   @"OBJECT_TYPE",
                             buildingID,       @"OBJECT_ID",
                             @"IDENTIFIER", @"TYPE", nil], @"TO",
                            [NSArray arrayWithObjects: @"SIDEWALK", @"CWSTR", @"CROSSWALK", @"CWSGSTR", nil], @"PATHTYPES", nil],
                           @"ARGUMENTS", nil];
    
    NSData* data = [self appendJSONDictionary:query toURL:baseURL];
    
    NSDictionary* content = [self fetchedData:data];    // TODO: should be executed in a seperate thread
    
    return [content objectForKey:@"GEOMETRY"];
}

@end
