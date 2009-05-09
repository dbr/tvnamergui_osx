#import "AppCon.h"

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
    for(id cur_file in theFiles){
        //NSLog(@"%@", cur_file);
    }
}

@synthesize theFiles;
@end
