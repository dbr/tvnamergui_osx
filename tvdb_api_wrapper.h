#import <Cocoa/Cocoa.h>

@interface tvdb_api_wrapper : NSObject {

}

-(NSMutableDictionary*) parseName:(NSString*)name;
-(NSString*)getEpisodeNameForSeries:(NSString*)seriesName
                             seasno:(NSNumber*)seasno
                               epno:(NSNumber*)epno;
                
@end
