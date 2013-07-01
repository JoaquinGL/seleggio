//
//  WeddingListDAO.h
//  SongsList
//
//  Created by Joaquin Giraldez on 26/06/13.
//  Copyright (c) 2013 Joaquin Giraldez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeddingListDAO : NSObject

- (void) insertWeding:(NSDictionary *) weddingObject;

- ( id ) getIdFormIndex: ( int )index;
- ( id ) getIDSongFromIDWedding: ( id )idWedding;

- ( NSInteger ) getNumberOfRegisters;

- ( id ) getNameFromIDWedding: ( id )idWedding;

- ( NSMutableArray * ) getTheSongsFormListWedding: (id) idWedding;

@end
