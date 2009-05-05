#import "AppCon.h"

@implementation AppCon

-(void)init{
    if(self = [super init]){
        theFiles = [NSMutableArray arrayWithObjects:
                    [NSMutableDictionary dictionaryWithObjectsAndKeys:
                     @"test.s01e01.this.is.really.long.name.avi", @"filename", 
                     [NSNumber numberWithBool:YES], @"rename",
                     [NSURL URLWithString:@""], @"path",
                     nil],
                    [NSMutableDictionary dictionaryWithObjectsAndKeys:
                     @"test.s01e01.this.is.really.long.name.avi", @"filename", 
                     [NSNumber numberWithBool:YES], @"rename",
                     [NSURL URLWithString:@""], @"path",
                     nil],
                    nil
        ];
    }
}

-(IBAction) rename: (id)sender{
    for(id cur_file in theFiles){
        NSLog(@"%@", cur_file);
    }
}

@synthesize theFiles;
@end
