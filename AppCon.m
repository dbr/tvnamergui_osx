#import "AppCon.h"

@implementation AppCon

-(id)init{
    if(self = [super init]){
        self.theFiles = [NSMutableArray arrayWithObjects:
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
