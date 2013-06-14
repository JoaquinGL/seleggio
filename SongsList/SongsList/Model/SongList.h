//
//  SongList.h
//  SongsList
//
//  Created by Joaquin Giraldez on 11/06/13.
//  Copyright (c) 2013 Joaquin Giraldez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SongList : NSObject
{
    NSString* songId_;
    NSString* title_;
    NSString* group_;
    NSString* videoURL_;
    NSString* imageURL_;
}

@property ( nonatomic, retain ) NSString* songId;
@property ( nonatomic, retain ) NSString* title;
@property ( nonatomic, retain ) NSString* group;
@property ( nonatomic, retain ) NSString* videoURL;
@property ( nonatomic, retain ) NSString* imageURL;

@end
