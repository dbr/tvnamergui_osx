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

-(IBAction)rename:(id)sender{
    [busy setHidden:NO];
    [busy startAnimation:self];
    
    tvdb_api_wrapper *api = [[tvdb_api_wrapper alloc] init];
    [api autorelease];
    
    for(id cur_file in theFiles){
        NSString *epname;
        
        NSLog(@"%@", epname);
        
        [busy setHidden:YES];
        [busy stopAnimation:self];
    }
}

@synthesize theFiles;
@end
