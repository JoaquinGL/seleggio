//
//  WeddingListModel.m
//  SongsList
//
//  Created by Joaquin Giraldez on 26/06/13.
//  Copyright (c) 2013 Joaquin Giraldez. All rights reserved.
//

#import "WeddingListModel.h"
#import "WeddingListDAO.h"
#import "WeddingList.h"

@implementation WeddingListModel
{
    WeddingListDAO *weddingListDAO;
}

- (void) initWeddingListDAO
{
    if(!weddingListDAO)
        weddingListDAO = [[WeddingListDAO alloc] init];
}

- (void) insertWeding:(NSDictionary *) weddingObject
{
    [self initWeddingListDAO];
    
    [weddingListDAO insertWeding:weddingObject];
}

- ( id )getIDFromIndex: ( NSInteger )index

{
    [self initWeddingListDAO];
    
    return [weddingListDAO getIdFormIndex:index];
}

- (id) getThelastWeddingID
{
    NSInteger numberOfRegisters = [weddingListDAO getNumberOfRegisters];
    
    id returnValue;
    
    if (numberOfRegisters == 0)
        returnValue = nil;
    else
        returnValue = [weddingListDAO getIdFormIndex:numberOfRegisters - 1 ];
    
    return returnValue;
}

- (id) getTheLastWeddingName
{
    [self initWeddingListDAO];
    
    id lastID = [self getThelastWeddingID];
    id returnValue;
    
    if(lastID)
        returnValue = [weddingListDAO getNameFromIDWedding: [self getThelastWeddingID]];
    else
        returnValue = nil;
    
    
    return returnValue;
}

- ( id ) getNameFromIDWedding: ( id )idWedding
{
    [self initWeddingListDAO];
    
    return [weddingListDAO getNameFromIDWedding: idWedding];

}

- ( id )getIDSongFromIDWedding: ( id )idWedding
{
    [self initWeddingListDAO];
    
    return [weddingListDAO getIDSongFromIDWedding: idWedding];
}

- ( NSInteger )getNumberOfRegisters
{
    [ self initWeddingListDAO ];
    
    return [ weddingListDAO getNumberOfRegisters ];
}

- ( NSMutableArray * ) getTheSongsFormListWedding: (id) idWedding
{
    [ self initWeddingListDAO ];
    
    return [weddingListDAO getTheSongsFormListWedding:idWedding];
}

- (void) deleteSong:( id ) keyToDelete : ( id ) weddingName
{
    [ self initWeddingListDAO];
    
    [weddingListDAO deleteFromDatabase:keyToDelete :weddingName];
    
}


@end
