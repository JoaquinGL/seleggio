//
//  InitialHome.m
//  SongsList
//
//  Created by Joaquin Giraldez on 12/06/13.
//  Copyright (c) 2013 Joaquin Giraldez. All rights reserved.
//

#import "InitialHome.h"
#import "Animation.h"
@interface InitialHome ()
{
    IBOutlet UIImageView* portraitBackgroundImage;
    IBOutlet UIImageView* landscapeBackgroundImage;
}
@end

@implementation InitialHome

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	    
     
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [landscapeBackgroundImage setAlpha:0];
    [portraitBackgroundImage setAlpha:0];

    (UIDeviceOrientationIsLandscape(self.interfaceOrientation)) ? ([landscapeBackgroundImage setAlpha:1]) : ([portraitBackgroundImage setAlpha:1]);
}


- (void)didReceiveMemoryWarning
{
    portraitBackgroundImage = nil;
    landscapeBackgroundImage = nil;
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Rotate method

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (UIDeviceOrientationIsLandscape(self.interfaceOrientation))
    {
        [Animation fadeInWithAnimation: portraitBackgroundImage
                               fadeOut: landscapeBackgroundImage];
    }
    else
    {
        [Animation fadeInWithAnimation: landscapeBackgroundImage
                               fadeOut: portraitBackgroundImage];
    }
    
}

@end
