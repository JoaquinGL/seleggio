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
    if ( !songListDAO )
        songListDAO = [ [ SongListDAO alloc ]init ];
}

- ( id )getIDFromIndex: ( NSInteger )index
{
    [ self initSongsListDAO ];
    
    return [ songListDAO getIdFormIndex: index ];
}

- ( id )getTitleWithId: ( id )idSong
{
    [ self initSongsListDAO ];
    
    return [ songListDAO getTitleWithId: idSong ];
}

- ( id )getGroupWithId: ( id )idSong
{
    [ self initSongsListDAO ];

    return [ songListDAO getGroupWithId: idSong ];
}

- ( id )getVideoWithId: ( id )idSong
{
    [ self initSongsListDAO ];

    return [ songListDAO getVideoWithId: idSong ];
}

- ( id )getImageWithId: ( id )idSong
{
    [ self initSongsListDAO ];

    return [ songListDAO getImageWithId: idSong ];
}

- ( int )getNumberOfRegisters
{
    [ self initSongsListDAO ];
    
    return [ songListDAO getNumberOfRegisters ];
}




@end
