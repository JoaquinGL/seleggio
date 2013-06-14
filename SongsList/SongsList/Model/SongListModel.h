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
- ( NSString* ) getIDFromIndex: ( NSInteger )index;

- (NSString *) getTitleWithId:(id) idSong;
- (NSString *) getGroupWithId:(id) idSong;
- (NSString *) getImageWithId:(id) idSong;
- (NSString *) getVideoWithId:(id) idSong;

@end
