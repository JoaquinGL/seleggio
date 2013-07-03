//
//  WeddingListModel.h
//  SongsList
//
//  Created by Joaquin Giraldez on 26/06/13.
//  Copyright (c) 2013 Joaquin Giraldez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeddingListModel : NSObject

- ( void )insertWeding: ( NSDictionary* )weddingObject;
- ( id )getIDFromIndex: ( NSInteger )index;
- ( id )getIDSongFromIDWedding:( id )idWedding;
- ( id )getNameFromIDWedding: ( id )idWedding;
- ( id )getTheLastWeddingName;
- ( NSInteger ) getNumberOfRegisters;

- ( NSMutableArray * ) getTheSongsFormListWedding: (id) idWedding;

- (void) deleteSong:( id ) keyToDelete : ( id ) weddingName;

@end
