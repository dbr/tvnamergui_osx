#import <Cocoa/Cocoa.h>


@interface TableListCon : NSObject {
    IBOutlet NSTableView *tableView;
    IBOutlet NSArrayController *ArrayCon;
    IBOutlet NSProgressIndicator *busy;
}

@end
