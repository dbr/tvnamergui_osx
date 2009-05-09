#import "tvdb_api_wrapper.h"

@implementation tvdb_api_wrapper
-(NSDictionary*)parseName:(NSString*)name
{
    return [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:2] forKey:@"seasno"];
}

-(NSString*)getEpisodeName:(NSNumber*)seasno
                   :(NSNumber*)epno
                   :(NSNumber*)sid
{
    return [NSString string];
}

@end
