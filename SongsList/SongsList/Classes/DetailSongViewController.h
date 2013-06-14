//
//  DetailSongViewController.h
//  SongsList
//
//  Created by Joaquin Giraldez on 10/06/13.
//  Copyright (c) 2013 Joaquin Giraldez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailSongViewController : UIViewController

{
    NSString *titleSongName_;
    NSString *groupName_;
    NSString *identifySong_;
}

@property (nonatomic, retain) IBOutlet NSString * titleSongName;
@property (nonatomic, retain) IBOutlet NSString * identifySong;
@property (nonatomic, retain) IBOutlet NSString * groupName;

- (void) setTitleViewInit:(NSString *)titleSongName;
- (void) setIdentify:(NSString *)identify;
- (void) setGroupNameInit:(NSString *)groupNameString;

@end
