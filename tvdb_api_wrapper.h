#import <Cocoa/Cocoa.h>

@interface tvdb_api_wrapper : NSObject {

}

-(NSMutableDictionary*) parseName:(NSString*)name;
-(NSString*) getEpisodeName:(NSNumber*)seasno
                               :(NSNumber*)epno
                               :(NSNumber*)sid;
@end
