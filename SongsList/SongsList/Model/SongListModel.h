//
//  SongListModel.h
//  SongsList
//
//  Created by Joaquin Giraldez on 11/06/13.
//  Copyright (c) 2013 Joaquin Giraldez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SongListModel : NSObject



- ( NSInteger ) getNumberOfRegisters;
- ( id )getIDFromIndex: ( NSInteger )index;

- ( id )getTitleWithId: ( id )idSong;
- ( id )getGroupWithId: ( id )idSong;
- ( id )getImageWithId: ( id )idSong;
- ( id )getVideoWithId: ( id )idSong;

@end
