#import "AppCon.h"
#import "tvdb_api_wrapper.h"

@implementation AppCon

-(void)awakeFromNib
{
    // Set TableList's array to blank array
    self.theFiles = [NSMutableArray array];
}

-(IBAction)renameFilesAction:(id)sender{
    [busy setHidden:NO];
    [busy startAnimation:self];
    
    tvdb_api_wrapper *api = [[tvdb_api_wrapper alloc] init];
    [api autorelease];
    
    for(id cur_file in theFiles){
        // Skip unselected files
        if([[cur_file objectForKey:@"rename"] isEqualTo:[NSNumber numberWithBool:NO]])
            continue;
        
        NSString *old_filepath = [cur_file objectForKey:@"path"];
        NSString *new_filename = [cur_file objectForKey:@"new_filename"];
        
        NSString *new_filepath = [[old_filepath stringByDeletingLastPathComponent]
                                  stringByAppendingPathComponent:new_filename];

        
        DebugLog(@"Renaming..\n%@\n..to..\n%@", old_filepath, new_filepath);

        BOOL worked = [[NSFileManager defaultManager] movePath:old_filepath toPath:new_filepath handler:nil];
        
        if(!worked)
            NSRunAlertPanel( @"PANIC!", 
                            [NSString stringWithFormat:@"%@ could not be renamed to %@",
                             old_filepath, new_filepath],
                            @"Oh well", nil, nil );
        
        [busy setHidden:YES];
        [busy stopAnimation:self];
    }
}

@synthesize theFiles;
@end
