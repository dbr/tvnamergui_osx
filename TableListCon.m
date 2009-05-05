#import "TableListCon.h"
#import "AppCon.h"

@implementation TableListCon
- (void)awakeFromNib
{
    [tableView setDraggingSourceOperationMask:NSDragOperationLink forLocal:NO];
    [tableView setDraggingSourceOperationMask:(NSDragOperationCopy |
                                               NSDragOperationMove) forLocal:YES];
    [tableView registerForDraggedTypes:[NSArray arrayWithObjects:
                                        NSFilenamesPboardType, nil]];
    [tableView setAllowsMultipleSelection:YES];
}

- (BOOL)tableView:(NSTableView *)aTableView
writeRowsWithIndexes:(NSIndexSet *)rowIndexes
     toPasteboard:(NSPasteboard *)pboard
{
    return YES;
}

- (NSDragOperation)tableView:(NSTableView*)tv
                validateDrop:(id <NSDraggingInfo>)info
                 proposedRow:(int)row
       proposedDropOperation:(NSTableViewDropOperation)op
{
    NSDragOperation dragOp = NSDragOperationCopy;
    return dragOp;
}

- (BOOL)tableView:(NSTableView*)tv
       acceptDrop:(id<NSDraggingInfo>)info
              row:(int)row
    dropOperation:(NSTableViewDropOperation)op
{
    NSPasteboard *pboard = [info draggingPasteboard];
    if ([[pboard types] containsObject:NSFilenamesPboardType])
    {
        NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];
        for(id file in files)
        {
            NSLog(@"%@", file);
        }
    }

    return YES;
}
@end
