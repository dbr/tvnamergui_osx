#import "TableListCon.h"

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

-(void)addFileToList:(NSString*)path
{
    NSLog(@"addFile %@", path);
    NSArray *components = [path pathComponents];
    NSString *filename = [components lastObject];
    
    // Generate dict of new file
    NSMutableDictionary *cfile = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  filename, @"filename", 
                                  [NSNumber numberWithBool:YES], @"rename",
                                  path, @"path",
                                  nil];
    
    // Add it to the tableView's array controller
    [ArrayCon addObject:cfile];
}

-(void)addDirectoryToList:(NSString*)path
{
    NSDirectoryEnumerator *direnum = [[NSFileManager defaultManager]
                                      enumeratorAtPath:path];
    NSString *pname;
    while (pname = [direnum nextObject])
    {
        if ([[[pname pathComponents] lastObject] hasPrefix:@"."])
        {
            /* hidden dot-file/folder, skip this and sub-dirs */
            [direnum skipDescendents];
        }
        else
        {
            [self addFileToList:pname];
        }
    }    
}

- (BOOL)tableView:(NSTableView*)tv
       acceptDrop:(id<NSDraggingInfo>)info
              row:(int)row
    dropOperation:(NSTableViewDropOperation)op
{
    NSPasteboard *pboard = [info draggingPasteboard];
    if([[pboard types] containsObject:NSFilenamesPboardType])
    {
        NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];
        for(id file in files)
        {
            BOOL isDir;
            if([[NSFileManager defaultManager]
                fileExistsAtPath:file isDirectory:&isDir] && isDir){
                [self addDirectoryToList:file];
                
            }else{
                [self addFileToList:file];
            }
        }
    
        // Done all files
        return YES;
    }
    
    return NO;
}
@end
