#import <Cocoa/Cocoa.h>

@interface tvdb_api_wrapper : NSObject {

}

-(NSMutableDictionary*) parseName:(NSString*)name;
-(NSMutableDictionary*)getSeriesId:(NSString*)seriesName;
-(NSString*)getEpNameForSid:(NSNumber*)sid
                     seasno:(NSNumber*)seasno
                       epno:(NSNumber*)epno;
@end
