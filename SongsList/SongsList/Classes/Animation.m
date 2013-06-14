//
//  Animation.m
//  SongsList
//
//  Created by Joaquin Giraldez on 12/06/13.
//  Copyright (c) 2013 Joaquin Giraldez. All rights reserved.
//

#import "Animation.h"

@implementation Animation


+ (void) fadeInWithAnimation: ( UIView* )viewToFadeIn
                     fadeOut: ( UIView* )viewToFadeOut
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [viewToFadeOut setAlpha:0];
                         
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    [UIView animateWithDuration:0.3
                          delay:0.1
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [viewToFadeIn setAlpha:1];
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
}


@end
