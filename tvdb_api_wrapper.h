#import <Cocoa/Cocoa.h>

@interface tvdb_api_wrapper : NSObject {

}

-(NSDictionary*) parseName:(NSString*)name;
-(NSString*) getEpisodeName:(NSNumber*)seasno
                               :(NSNumber*)epno
                               :(NSNumber*)sid;
@end
