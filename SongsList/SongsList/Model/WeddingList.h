//
//  WeddingList.h
//  SongsList
//
//  Created by Joaquin Giraldez on 26/06/13.
//  Copyright (c) 2013 Joaquin Giraldez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeddingList : NSObject
{
    NSString* weddingID_;
    NSString* name_;
    NSString* IDSongDetail_;
}

@property ( nonatomic, retain ) NSString* weddingID;
@property ( nonatomic, retain ) NSString* name;
@property ( nonatomic, retain ) NSString* IDSongDetail;

@end
