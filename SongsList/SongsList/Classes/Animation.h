//
//  Animation.h
//  SongsList
//
//  Created by Joaquin Giraldez on 12/06/13.
//  Copyright (c) 2013 Joaquin Giraldez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Animation : NSObject

+ (void) fadeInWithAnimation: ( UIView* )viewToFadeIn
                     fadeOut: ( UIView* )viewToFadeOut;

@end
