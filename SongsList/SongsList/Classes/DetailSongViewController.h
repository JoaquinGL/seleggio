//
//  DetailSongViewController.h
//  SongsList
//
//  Created by Joaquin Giraldez on 10/06/13.
//  Copyright (c) 2013 Joaquin Giraldez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QBKOverlayMenuView.h"
#import "MBProgressHUD.h"

@interface DetailSongViewController : UIViewController<QBKOverlayMenuViewDelegate, MBProgressHUDDelegate, UIAlertViewDelegate, UITextFieldDelegate>

{
    NSString *songName_;
    NSString *groupName_;
    NSString *videoURL_;
    NSString *idSong_;
}

@property (nonatomic, retain) IBOutlet NSString * songName;
@property (nonatomic, retain) IBOutlet NSString * videoURL;
@property (nonatomic, retain) IBOutlet NSString * groupName;
@property (nonatomic, retain) IBOutlet NSString * idSong;

- (void) setTitleViewInit:(NSString *)titleSongName;
- (void) setURLVideo:(NSString *)identify;
- (void) setGroupNameInit:(NSString *)groupNameString;

- (void) setIDSong: ( NSString * )idSong
       setSongName: ( NSString * )songName
      setGroupName: ( NSString * )groupName
       setVideoURL: ( NSString * )videoURL;

@end
