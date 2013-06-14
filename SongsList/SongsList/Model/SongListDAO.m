//
//  SongListDAO.m
//  SongsList
//
//  Created by Joaquin Giraldez on 11/06/13.
//  Copyright (c) 2013 Joaquin Giraldez. All rights reserved.
//

#import "SongListDAO.h"
#import "SongList.h"

@implementation SongListDAO
{
    NSMutableArray *songsContent;
    NSMutableDictionary *songsContentDictionary;
}


- ( NSMutableArray* ) getMySongs
{
    @try {
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        
        NSString *dbPath = [[[ NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"songsList.sqlite"];
        BOOL success = [ fileMgr fileExistsAtPath:dbPath ];
    
        if (!success)
            NSLog(@"Cannot locate database file '%@'.", dbPath);
        if (!(sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK))
        {
            NSLog(@"An error has ocurred");
        }
        
        const char *sql = "SELECT Id, TitleName, GroupName, VideoURL, ImageURL FROM songsDetails";
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare(db, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
             NSLog(@"Problem with prepare statement");
        }
        
        while (sqlite3_step(sqlStatement) == SQLITE_ROW)
        {
            SongList *songList = [[SongList alloc]init];
            songList.songId = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 0)];
            songList.title = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 1)];
            songList.group = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 2)];
            songList.videoURL = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 3)];
            songList.imageURL = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 4)];
            
            [songsContentDictionary setObject:songList forKey:songList.songId];
            
            [songsContent addObject:songList];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        return songsContent;
    }
}

- (void) initSongsContent
{
    if (!songsContent)
    {
        songsContent = [[NSMutableArray alloc] init];
        songsContentDictionary = [[NSMutableDictionary alloc] init];
        songsContent = [self getMySongs];
    }
}

- (NSString *) getIdFormIndex:(int) index
{
    [self initSongsContent];
    
    NSString *idSong = ( ( SongList* ) [ songsContent objectAtIndex:index ]).songId;
    
    return idSong;
}

- (NSString *) getTitleWithId:(id) idSong
{
    return (( SongList* )[songsContentDictionary objectForKey:idSong]).title;
}

- (NSString *) getGroupWithId:(id) idSong
{
    return (( SongList* )[songsContentDictionary objectForKey:idSong]).group;
}

- (NSString *) getVideoWithId:(id) idSong
{
    return (( SongList* )[songsContentDictionary objectForKey:idSong]).videoURL;
}

- (NSString *) getImageWithId:(id) idSong
{
    return (( SongList* )[songsContentDictionary objectForKey:idSong]).imageURL;
}


- ( NSInteger ) getNumberOfRegisters
{
    [self initSongsContent];
    return [songsContentDictionary count];
}



@end
