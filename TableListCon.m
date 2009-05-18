#import "TableListCon.h"
#import "tvdb_api_wrapper.h"

@implementation TableListCon
- (void)awakeFromNib
{
    [tableView setDraggingSourceOperationMask:NSDragOperationLink forLocal:NO];
    [tableView setDraggingSourceOperationMask:(NSDragOperationCopy | NSDragOperationMove) forLocal:YES];
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

- (void)addFileToList:(NSString*)path
{
    NSArray *components = [path pathComponents];
    NSString *old_filename = [components lastObject];
    
    tvdb_api_wrapper *api = [[tvdb_api_wrapper alloc] init];
    [api autorelease];
    
    // Parse name, get: series_filename, seasno, epno
    NSMutableDictionary *parsed_name = [api parseName:old_filename];
    if(!parsed_name) return; // Invalid filename
    
    NSMutableDictionary *seriesinfo = [api getSeriesId:[parsed_name objectForKey:@"file_seriesname"]];
    DebugLog(@"Got series %@ with ID %@",
             [seriesinfo objectForKey:@"name"],
             [seriesinfo objectForKey:@"sid"]);
    
    NSString *epname = [api getEpNameForSid:
                        [NSNumber numberWithLong:[[seriesinfo objectForKey:@"sid"] doubleValue]]
                                     seasno:[parsed_name objectForKey:@"seasno"]
                                       epno:[parsed_name objectForKey:@"epno"]];
    NSString *extention = [parsed_name objectForKey:@"ext"];
    
    NSString *new_filename;
    
    if(epname){
        DebugLog(@"Got episode name: %@", epname);
        new_filename = [NSString stringWithFormat:@"%@ - [%02dx%02d] - %@.%@",
                        [seriesinfo objectForKey:@"name"],
                        [[parsed_name objectForKey:@"seasno"] intValue],
                        [[parsed_name objectForKey:@"epno"] intValue],
                        epname,
                        extention
                        ];
    }
    else
    {
        new_filename = [NSString stringWithFormat:@"%@ - [%02dx%02d].%@",
                        [parsed_name objectForKey:@"file_seriesname"],
                        [[parsed_name objectForKey:@"seasno"] intValue],
                        [[parsed_name objectForKey:@"epno"] intValue],
                        epname,
                        extention
                        ];
        
    }
    
    NSString *displaystr = [NSString stringWithFormat:@"Old: %@\nNew: %@",
                            old_filename,
                            new_filename
    ];
    
    // Generate dict of new file
    NSDictionary *cfile = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                           displaystr, @"displaystr",
                           [NSNumber numberWithBool:YES], @"rename",
                           path, @"path",
                           old_filename, @"old_filename",
                           new_filename, @"new_filename",
                           parsed_name, @"parsed_name",
                           nil];
    
    // Add it to the tableView's array controller
    [ArrayCon addObject:cfile];
}

- (void)addDirectoryToList:(NSString*)path
{
    NSDirectoryEnumerator *direnum = [[NSFileManager defaultManager]
                                      enumeratorAtPath:path];
    NSString *pname;
    while (pname = [direnum nextObject])
    {
        if ([[[pname pathComponents] lastObject] hasPrefix:@"."])
        {
            // hidden dot-file/folder, skip this and sub-dirs
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
    [busy setHidden:NO];
    [busy startAnimation:self];
    
    NSPasteboard *pboard = [info draggingPasteboard];
    if([[pboard types] containsObject:NSFilenamesPboardType])
    {
        NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];
        for(id file in files)
        {
            BOOL isDir;
            if([[NSFileManager defaultManager]
                fileExistsAtPath:file isDirectory:&isDir] && isDir)
                [self addDirectoryToList:file];
            else
                [self addFileToList:file];
        }
        
        // Done all files
        [busy setHidden:YES];
        [busy stopAnimation:self];
        return YES;
    }
    
    [busy setHidden:YES];
    [busy stopAnimation:self];
    return NO;
}
@end
