#import <Cocoa/Cocoa.h>


@interface AppCon : NSObject {
    NSMutableArray *theFiles;
}

-(IBAction)rename: (id)sender;
@property (copy) NSMutableArray *theFiles;
@end
