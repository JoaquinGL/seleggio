//
//  WeddingListDAO.m
//  SongsList
//
//  Created by Joaquin Giraldez on 26/06/13.
//  Copyright (c) 2013 Joaquin Giraldez. All rights reserved.
//

#import "WeddingListDAO.h"
#import <sqlite3.h>
#import "WeddingList.h"

@implementation WeddingListDAO
{
    NSMutableArray *weddingContent;
    NSMutableDictionary *weddingListContentDictionay;
    NSString *dbPath;
    NSString *databasename;
    sqlite3 *songDB;
}


- (void)createEditableCopyOfDatabaseIfNeeded {
    // First, test for existence.
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"songsList.sqlite"];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success) return;
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"songsList.sqlite"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}


- (void) initDatabase
{
    
        NSString* docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
       dbPath = [docPath stringByAppendingPathComponent:@"songsList.sqlite"];
        
        if (sqlite3_open([dbPath UTF8String], &songDB) != SQLITE_OK) {
            NSLog(@"Failed to open database!");
        }
    
}

- ( NSMutableArray* ) getMyListWedding
{
    @try {
        
        [self initDatabase];
        
        const char *sql = "SELECT ID, Name, IDSongDetail, OrderSong FROM weddingList";
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare(songDB, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement");
        }
        
        while (sqlite3_step(sqlStatement) == SQLITE_ROW)
        {
            WeddingList* weddingList = [ [ WeddingList alloc ]init ];
            weddingList.weddingID = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 0)];
            weddingList.name = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 1)];
            weddingList.IDSongDetail = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 2)];
            weddingList.order = [[NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 3)] intValue];
            [weddingListContentDictionay setObject: weddingList
                                            forKey: weddingList.weddingID];
            
            [weddingContent addObject:weddingList];
        }
        
        
        sqlite3_finalize(sqlStatement);
        sqlite3_close(songDB);
        
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        
        if (!(sqlite3_close(songDB)!= SQLITE_OK))
        {
            NSLog(@"An error has ocurred");
        }
        return weddingContent;
    }
}


- (void) deleteFromDatabase:( id ) keyToDelete : (id) weddingName{
    
    [self createEditableCopyOfDatabaseIfNeeded];
    
    [self initDatabase];
    
    sqlite3_stmt *delete_statment = NULL;
    
    const char *sql = "DELETE FROM weddingList WHERE Name=?";
    
    if (keyToDelete)
    {
       sql = "DELETE FROM weddingList WHERE IDSongDetail=? AND Name=?";
    }
    
	if (delete_statment == nil) {
		//const char *sql = "DELETE FROM weddingList WHERE IDSongDetail=? AND Name=?";
		if (sqlite3_prepare_v2(songDB, sql, -1, &delete_statment, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(songDB));
		}
	}
    
	    
    if (keyToDelete)
    {
        sqlite3_bind_text(delete_statment, 1, [keyToDelete UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(delete_statment, 2, [weddingName UTF8String], -1, SQLITE_TRANSIENT);
    }else
    {
         sqlite3_bind_text(delete_statment, 1, [weddingName UTF8String], -1, SQLITE_TRANSIENT);
    }
    

    
	int success = sqlite3_step(delete_statment);
	
	if (success != SQLITE_DONE) {
		 NSLog( @"Error: failed to save priority with message '%s'.",sqlite3_errmsg(songDB));
	}
	
	sqlite3_reset(delete_statment);
    
    sqlite3_close(songDB);
}


- (void) insertWeding:(NSDictionary *) weddingObject
{
    @try {
        
        
        [self createEditableCopyOfDatabaseIfNeeded];
        
        [self initDatabase];
        
        const char *sql = "INSERT INTO weddingList (ID, Name, IDSongDetail, OrderSong) VALUES(?,?,?,?)";
        
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(songDB, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement");
        }
        
        
        NSLog(@"%@",[weddingObject objectForKey:@"ID"]);
        NSLog(@"%@",[weddingObject objectForKey:@"Name"]);
        NSLog(@"%@",[weddingObject objectForKey:@"IDSongDetail"]);
        
        sqlite3_bind_text(sqlStatement, 1, [[weddingObject objectForKey:@"ID"] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(sqlStatement, 2, [[weddingObject objectForKey:@"Name"] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(sqlStatement, 3, [[weddingObject objectForKey:@"IDSongDetail"] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(sqlStatement, 4, [@"-1" UTF8String], -1, SQLITE_TRANSIENT);
        
        if(SQLITE_DONE != sqlite3_step(sqlStatement))
            NSLog(@"An exception occured: Insertar en la BBDD");
        
        else
            NSLog(@"Inserted");
        
        
        sqlite3_reset(sqlStatement);
        sqlite3_finalize(sqlStatement);
        
        sqlite3_close(songDB);
        
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    
}

- (void) initWeddingContent
{
    if (!weddingContent)
    {
        weddingContent = [[NSMutableArray alloc] init];
        weddingListContentDictionay = [[NSMutableDictionary alloc] init];
        weddingContent = [self getMyListWedding];
    }
}


- ( id ) getIdFormIndex: ( int )index
{
    [ self initWeddingContent ];
    
    NSString *idWedding = ( ( WeddingList* ) [ weddingContent objectAtIndex:index ]).weddingID;
    
    return idWedding;
}

- ( NSMutableArray * ) getTheSongsFormListWedding: (id) idWedding
{
    
    NSMutableArray *songList = [[NSMutableArray alloc] init];
    
    [self initWeddingContent];
    
    WeddingList *list;
    
    for (int i = 0; i<[weddingContent count]; i++)
    {
        
        list = [weddingContent objectAtIndex:i];
        
        if ([list.name isEqual:idWedding])
        {
            [songList addObject:list.IDSongDetail];
        }
    }

    return songList;
}


- ( id ) getNameFromIDWedding: ( id )idWedding
{
    return (( WeddingList* )[weddingListContentDictionay objectForKey:idWedding]).name;
}



- ( id ) getIDSongFromIDWedding: ( id )idWedding
{
    return (( WeddingList* )[weddingListContentDictionay objectForKey:idWedding]).IDSongDetail;
}


- ( NSInteger ) getNumberOfRegisters
{
    [self initWeddingContent];
    return [weddingListContentDictionay count];
}


@end
