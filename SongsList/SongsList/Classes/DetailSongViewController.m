//
//  DetailSongViewController.m
//  SongsList
//
//  Created by Joaquin Giraldez on 10/06/13.
//  Copyright (c) 2013 Joaquin Giraldez. All rights reserved.
//

#import "DetailSongViewController.h"
#import "XCDYouTubeVideoPlayerViewController.h"
#import "Defines.h"
#import "Animation.h"
#import "Reachability.h"

#define URL_YOUTUBE @"https://gdata.youtube.com/feeds/api/standardfeeds/on_the_web?v=2&alt=json&max-results=1"


@interface DetailSongViewController () <UITextFieldDelegate>
{
    NSArray* videoList;
    NSArray* groupList;
    
    IBOutlet UILabel* titleSongLabel;
    IBOutlet UILabel* groupLabel;
    
    IBOutlet UIImageView* portraitBackgroundImage;
    IBOutlet UIImageView* landscapeBackgroundImage;
    NetworkStatus remoteHostStatus;
    Reachability *reachability;
}

@property (nonatomic, weak) IBOutlet UISwitch *lowQualitySwitch;
@property (nonatomic, weak) IBOutlet UIView *videoContainerView;
@property (nonatomic, strong) XCDYouTubeVideoPlayerViewController *videoPlayerViewController;

@end

@implementation DetailSongViewController

@synthesize
    titleSongName = titleSongName_,
    identifySong = identifySong_,
    groupName = groupName_;

- (void) didReceiveMemoryWarning
{
    
    self.titleSongName = nil;
    self.identifySong = nil;
    
    groupLabel = nil;
    videoList = nil;
    titleSongLabel = nil;
    
    portraitBackgroundImage = nil;
    landscapeBackgroundImage = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super didReceiveMemoryWarning];
}

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerPlaybackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerPlaybackStateDidChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerLoadStateDidChange:) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];

    titleSongLabel.text =  self.titleSongName;
    
    groupLabel.text = self.groupName;
    
    [landscapeBackgroundImage setAlpha:0];
    [portraitBackgroundImage setAlpha:0];
    
    (UIDeviceOrientationIsLandscape(self.interfaceOrientation)) ? ([landscapeBackgroundImage setAlpha:1]) : ([portraitBackgroundImage setAlpha:1]);
    
    
    
    [self initNetwork];
}



- (IBAction)dismissView:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) initNetwork
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNetworkChange:) name:kReachabilityChangedNotification object:nil];
    
    reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    remoteHostStatus = [reachability currentReachabilityStatus];
    
    if(remoteHostStatus == NotReachable) {NSLog(@"no");}
    else if (remoteHostStatus == ReachableViaWiFi) {NSLog(@"wifi"); }
    else if (remoteHostStatus == ReachableViaWWAN) {NSLog(@"cell"); }
}

- (void) handleNetworkChange:(NSNotification *)notice
{
    
    remoteHostStatus = [reachability currentReachabilityStatus];
    
    if(remoteHostStatus == NotReachable) {NSLog(@"no");}
    else if (remoteHostStatus == ReachableViaWiFi) {NSLog(@"wifi"); }
    else if (remoteHostStatus == ReachableViaWWAN) {NSLog(@"cell"); }
}


- (IBAction) playYouTubeVideo:(id)sender
{
    if(remoteHostStatus != NotReachable)
    {
        if (remoteHostStatus == ReachableViaWiFi)
        {
            self.lowQualitySwitch.on = NO;
        }
        else
        {
            self.lowQualitySwitch.on = YES;
        }
        
        self.videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:self.identifySong];
        
        if (self.lowQualitySwitch.on)
            self.videoPlayerViewController.preferredVideoQualities = @[ @(XCDYouTubeVideoQualitySmall240), @(XCDYouTubeVideoQualityMedium360) ];
        
        [self.videoPlayerViewController presentInView:self.videoContainerView];
    }
}

- (IBAction) playTrendingVideo:(id)sender
{
	XCDYouTubeVideoPlayerViewController *videoPlayerViewController = [XCDYouTubeVideoPlayerViewController new];
    
    [self.videoContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [videoPlayerViewController presentInView:self.videoContainerView];
	
	NSURL *url = [NSURL URLWithString:URL_YOUTUBE];
    
	[ NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url]
                                       queue:[NSOperationQueue new]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    {
		id json = [ NSJSONSerialization JSONObjectWithData: data ?: [ NSData new ]
                                                   options: 0
                                                     error: NULL ];
        
		NSString *videoIdentifier = [ [ [ json valueForKeyPath:@"feed.entry.media$group.yt$videoid.$t"] lastObject] description];
		
        videoPlayerViewController.videoIdentifier = videoIdentifier;
	}
     ];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
	[self playYouTubeVideo:textField];
	return YES;
}


#pragma mark - Notifications

- (void) moviePlayerPlaybackDidFinish:(NSNotification *)notification
{
	MPMovieFinishReason finishReason = [notification.userInfo[MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] integerValue];
	NSError *error = notification.userInfo[XCDMoviePlayerPlaybackDidFinishErrorUserInfoKey];
	NSString *reason = @"Unknown";
	switch (finishReason)
	{
		case MPMovieFinishReasonPlaybackEnded:
			reason = @"Playback Ended";
			break;
		case MPMovieFinishReasonPlaybackError:
			reason = @"Playback Error";
			break;
		case MPMovieFinishReasonUserExited:
			reason = @"User Exited";
			break;
	}
	NSLog(@"Finish Reason: %@%@", reason, error ? [@"\n" stringByAppendingString:[error description]] : @"");
}

- (void) moviePlayerPlaybackStateDidChange:(NSNotification *)notification
{
	MPMoviePlayerController *moviePlayerController = notification.object;
	NSString *playbackState = @"Unknown";
	switch (moviePlayerController.playbackState)
	{
		case MPMoviePlaybackStateStopped:
			playbackState = @"Stopped";
			break;
		case MPMoviePlaybackStatePlaying:
			playbackState = @"Playing";
			break;
		case MPMoviePlaybackStatePaused:
			playbackState = @"Paused";
			break;
		case MPMoviePlaybackStateInterrupted:
			playbackState = @"Interrupted";
			break;
		case MPMoviePlaybackStateSeekingForward:
			playbackState = @"Seeking Forward";
			break;
		case MPMoviePlaybackStateSeekingBackward:
			playbackState = @"Seeking Backward";
			break;
	}
	NSLog(@"Playback State: %@", playbackState);
}

- (void) moviePlayerLoadStateDidChange:(NSNotification *)notification
{
	MPMoviePlayerController *moviePlayerController = notification.object;
	
	NSMutableString *loadState = [NSMutableString new];
	MPMovieLoadState state = moviePlayerController.loadState;
	if (state & MPMovieLoadStatePlayable)
		[loadState appendString:@" | Playable"];
	if (state & MPMovieLoadStatePlaythroughOK)
		[loadState appendString:@" | Playthrough OK"];
	if (state & MPMovieLoadStateStalled)
		[loadState appendString:@" | Stalled"];
	
	NSLog(@"Load State: %@", loadState.length > 0 ? [loadState substringFromIndex:3] : @"N/A");
}

- (void) setTitleViewInit:(NSString *)titleSongName
{
    self.titleSongName = titleSongName;
}
- (void) setIdentify:(NSString *)identify
{
    self.identifySong = identify;
}

- (void) setGroupNameInit:(NSString *)groupNameString
{
    self.groupName = groupNameString;
}


#pragma mark -Rotate method

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
