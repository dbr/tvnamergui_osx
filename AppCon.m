#import "AppCon.h"
#import "tvdb_api_wrapper.h"

@implementation AppCon

-(id)init{
    if(self = [super init]){
        self.theFiles = [NSMutableArray array];
        return self;
    }
    else {
        return nil;
    }

}

-(IBAction) rename: (id)sender{
    tvdb_api_wrapper *api = [[tvdb_api_wrapper alloc] init];
    
    for(id cur_file in theFiles){
        NSMutableDictionary *parsed_name = [api parseName:
                                            [cur_file objectForKey:@"filename"]];
        NSString *epname = [api getEpisodeNameForSeries:[parsed_name objectForKey:@"file_seriesname"]
                                                 seasno:[parsed_name objectForKey:@"seasno"]
                                                   epno:[parsed_name objectForKey:@"epno"]];
        NSLog(@"%@", parsed_name);
        NSLog(@"%@", epname);
    }
}

@synthesize theFiles;
@end
