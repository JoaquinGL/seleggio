//
//  DetailSongViewController.h
//  SongsList
//
//  Created by Joaquin Giraldez on 10/06/13.
//  Copyright (c) 2013 Joaquin Giraldez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

#import "RESideMenu.h"

#define IS_WIDESCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@interface DetailSongViewController : UIViewController <  MBProgressHUDDelegate, UIAlertViewDelegate, UITextFieldDelegate >

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

@property (strong, readwrite, nonatomic) RESideMenu *sideMenu;

- (void) setTitleViewInit:(NSString *)titleSongName;
- (void) setURLVideo:(NSString *)identify;
- (void) setGroupNameInit:(NSString *)groupNameString;

- (void) setIDSong: ( NSString * )idSong
       setSongName: ( NSString * )songName
      setGroupName: ( NSString * )groupName
       setVideoURL: ( NSString * )videoURL;

@end
