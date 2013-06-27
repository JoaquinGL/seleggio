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
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    dbPath = [[[ NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"songsList.sqlite"];
    BOOL success = [ fileMgr fileExistsAtPath:dbPath ];
    
    if (!success)
        NSLog(@"Cannot locate database file '%@'.", dbPath);
    if (!(sqlite3_open([dbPath UTF8String], &songDB) == SQLITE_OK))
    {
        NSLog(@"An error has ocurred");
    }
}

- ( NSMutableArray* ) getMyListWedding
{
    @try {
        
        [self initDatabase];
        
        const char *sql = "SELECT ID, Name, IDSongDetail FROM weddingList";
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

- (void) insertWeding:(NSDictionary *) weddingObject
{
    @try {
        
        
        [self createEditableCopyOfDatabaseIfNeeded];
        [self initDatabase];
        
        const char *sql = "INSERT INTO weddingList (ID, name, IDSongDetail) VALUES(?,?,?)";
        
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(songDB, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement");
        }
        
        
        sqlite3_bind_text(sqlStatement, 1, [[weddingObject objectForKey:@"ID"] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(sqlStatement, 2, [[weddingObject objectForKey:@"name"] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(sqlStatement, 3, [[weddingObject objectForKey:@"IDSongDetail"] UTF8String], -1, SQLITE_TRANSIENT);
        
        
        
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