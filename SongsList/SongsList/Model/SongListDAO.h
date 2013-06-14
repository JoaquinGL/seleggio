//
//  SongListDAO.h
//  SongsList
//
//  Created by Joaquin Giraldez on 11/06/13.
//  Copyright (c) 2013 Joaquin Giraldez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface SongListDAO : NSObject
{
    sqlite3* db;
}



- ( NSInteger ) getNumberOfRegisters;
- (NSString *) getIdFormIndex:(int) index;

- (NSString *) getTitleWithId:(id) idSong;
- (NSString *) getGroupWithId:(id) idSong;
- (NSString *) getVideoWithId:(id) idSong;
- (NSString *) getImageWithId:(id) idSong;


@end
