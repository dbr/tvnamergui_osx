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
    NSLog(@"%@", theFiles);
    tvdb_api_wrapper *api = [[tvdb_api_wrapper alloc] init];
    for(id cur_file in theFiles){
        //NSLog(@"%@", cur_file);
    }
}

@synthesize theFiles;
@end
