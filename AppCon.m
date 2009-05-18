#import "AppCon.h"
#import "tvdb_api_wrapper.h"

@implementation AppCon

-(void)awakeFromNib
{
    // Set TableList's array to blank array
    self.theFiles = [NSMutableArray array];
}

-(NSString*)getNewFileName:(NSString*)old_filename
{
    tvdb_api_wrapper *api = [[tvdb_api_wrapper alloc] init];
    [api autorelease];
    
    // Parse name, get: series_filename, seasno, epno
    NSMutableDictionary *parsed_name = [api parseName:old_filename];
    if(!parsed_name) return nil; // Invalid filename
    
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
    
    return new_filename;
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
