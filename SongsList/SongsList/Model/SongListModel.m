//
//  SongListModel.m
//  SongsList
//
//  Created by Joaquin Giraldez on 11/06/13.
//  Copyright (c) 2013 Joaquin Giraldez. All rights reserved.
//

#import "SongListModel.h"
#import "SongListDAO.h"
#import "SongList.h"

@implementation SongListModel
{
    SongListDAO *songListDAO;

}

- (void) initSongsListDAO
{
    if(!songListDAO)
        songListDAO = [[SongListDAO alloc] init];
}

- ( NSString* ) getIDFromIndex: ( NSInteger )index
{
    [self initSongsListDAO];
    
    return [songListDAO getIdFormIndex:index];
}

- (NSString *) getTitleWithId:(id) idSong
{
    return [songListDAO getTitleWithId:idSong];
}

- (NSString *) getGroupWithId:(id) idSong
{
    return [songListDAO getGroupWithId:idSong];
}

- (NSString *) getVideoWithId:(id) idSong
{
    return [songListDAO getVideoWithId:idSong];
}

- (NSString *) getImageWithId:(id) idSong
{
    return [songListDAO getImageWithId:idSong];
}

- ( int ) getNumberOfRegisters
{
    [self initSongsListDAO];
    
    return [songListDAO getNumberOfRegisters];
}




@end
