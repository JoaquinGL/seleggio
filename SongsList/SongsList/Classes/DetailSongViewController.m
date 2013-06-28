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
#import "QBKOverlayMenuView.h"
#import "WeddingListModel.h"


#define URL_YOUTUBE @"https://gdata.youtube.com/feeds/api/standardfeeds/on_the_web?v=2&alt=json&max-results=1"


@interface DetailSongViewController () <UITextFieldDelegate>
{
    NSArray* videoList;
    NSArray* groupList;
    NSString *weddingName;
    BOOL saveWeddingName;
    UIAlertView *weddingListNameAlert;
    IBOutlet UILabel* titleSongLabel;
    IBOutlet UILabel* groupLabel;
    
    IBOutlet UIImageView* portraitBackgroundImage;
    IBOutlet UIImageView* landscapeBackgroundImage;
    NetworkStatus remoteHostStatus;
    Reachability *reachability;
    WeddingListModel *weddingListModel;
    QBKOverlayMenuView *_qbkOverlayMenuView;
}

@property (nonatomic, weak) IBOutlet UISwitch *lowQualitySwitch;
@property (nonatomic, weak) IBOutlet UIView *videoContainerView;
@property (nonatomic, strong) XCDYouTubeVideoPlayerViewController *videoPlayerViewController;

typedef enum {
    optionsList,
    removeFromList,
    addToList
} SongListOptionSelect;


@end

@implementation DetailSongViewController

@synthesize
    songName = songName_,
    videoURL = videoURL_,
    groupName = groupName_,
    idSong = idSong_;

- (void) didReceiveMemoryWarning
{
    
    self.songName = nil;
    self.videoURL = nil;
    
    groupLabel = nil;
    videoList = nil;
    titleSongLabel = nil;
    
    portraitBackgroundImage = nil;
    landscapeBackgroundImage = nil;
    
    _qbkOverlayMenuView = nil;
    
    self.idSong = nil;
    
    weddingListModel = nil;
    
    weddingListNameAlert = nil;
    
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
    
    [self initNotifications];
    
    titleSongLabel.text =  self.songName;
    
    groupLabel.text = self.groupName;
    
    [landscapeBackgroundImage setAlpha:0];
    [portraitBackgroundImage setAlpha:0];
    
    (UIDeviceOrientationIsLandscape(self.interfaceOrientation)) ? ([landscapeBackgroundImage setAlpha:1]) : ([portraitBackgroundImage setAlpha:1]);
    
    [self initNetwork];
    
    [self initMenu];
    
    saveWeddingName = NO;

}

- (void) initNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayerPlaybackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayerPlaybackStateDidChange:)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:nil];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayerLoadStateDidChange:)
                                                 name:MPMoviePlayerLoadStateDidChangeNotification
                                               object:nil];
}

- (void) initMenu
{
    QBKOverlayMenuViewOffset offset;
    offset.bottomOffset = 44;
    
    _qbkOverlayMenuView = [[QBKOverlayMenuView alloc] initWithDelegate:self position:kQBKOverlayMenuViewPositionTop offset:offset];
    [_qbkOverlayMenuView setParentView:[self view]];
    
    [_qbkOverlayMenuView addButtonWithImage:[UIImage imageNamed:@"selectList-button.png"] index:0];
    [_qbkOverlayMenuView addButtonWithImage:[UIImage imageNamed:@"cross-button.png"] index:1];
    [_qbkOverlayMenuView addButtonWithImage:[UIImage imageNamed:@"rw-button.png"] index:2];
    
}



- (IBAction)dismissView:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) initNetwork
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNetworkChange:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
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
        
        self.videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:self.videoURL];
        
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
    self.songName = titleSongName;
}
- (void) setURLVideo:(NSString *)identify
{
    self.videoURL = identify;
}

- (void) setGroupNameInit:(NSString *)groupNameString
{
    self.groupName = groupNameString;
}


- (void) setIDSong: ( NSString * )idSong
       setSongName: ( NSString * )songName
      setGroupName: ( NSString * )groupName
       setVideoURL: ( NSString * )videoURL
{
    self.idSong = idSong;
    self.songName = songName;
    self.groupName = groupName;
    self.videoURL = videoURL;
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

#pragma mark - Métodos de QBKOverlayMenuViewDelegate
- (void)overlayMenuView:(QBKOverlayMenuView *)overlayMenuView didActivateAdditionalButtonWithIndex:(NSInteger)index
{
    NSLog(@"Botón pulsado con índice: %d", index);
    
    if (!weddingListModel)
        weddingListModel = [[WeddingListModel alloc] init];
    
    switch (index) {
        case optionsList:
            {
                [self showPrompt];
            
                [_qbkOverlayMenuView mainButtonPressed];
            }
            break;
            
        case removeFromList:
            // de la lista que actualmente esta.
            break;
            
        case addToList:
        {
            NSLog(@"-> SongID:%@ ",self.idSong);
            NSLog(@"-> SongName:%@ ",self.songName);
            NSLog(@"-> SongGroup:%@ ",self.groupName);
            
            
            // Si El listado de bodas esta Vacio, hay que forzar a escribir el nombre de la boda.
            
            weddingName = [weddingListModel getTheLastWeddingName];
            
            if (! weddingName)
                [self showPrompt];
            else
            {
                [self saveWeddingName];
            }
            
            [_qbkOverlayMenuView mainButtonPressed];
            
        }
            break;
            
        default:
            break;
    }
}


- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    
    saveWeddingName = (![textField.text isEqualToString:@""]);
    
	[textField resignFirstResponder];
    return YES;
}

- (void) showPrompt
{
   weddingListNameAlert = [[UIAlertView alloc] initWithTitle:@"Añadir a listado de bodas" message:@"\n\n\n"
                                                           delegate:self cancelButtonTitle:NSLocalizedString(@"Cancelar",nil) otherButtonTitles:NSLocalizedString(@"Guardar",nil), nil];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12,50,260,25)];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.shadowColor = [UIColor blackColor];
    titleLabel.shadowOffset = CGSizeMake(0,-1);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"Nombre de la boda";
    
    [weddingListNameAlert addSubview:titleLabel];

    UITextField *weddingNameField = [[UITextField alloc] initWithFrame:CGRectMake(16,83,252,25)];
    weddingNameField.font = [UIFont systemFontOfSize:18];
    weddingNameField.backgroundColor = [UIColor whiteColor];
    
    weddingNameField.keyboardAppearance = UIKeyboardAppearanceAlert;
    weddingNameField.delegate = self;
    
    [weddingNameField becomeFirstResponder];
    [weddingListNameAlert addSubview:weddingNameField];
    
   
    [weddingListNameAlert show];

}

- (void) saveWeddingName
{
    NSString *guid = [self GetUUID];
    
    NSDictionary * weddingContent = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     guid,@"ID"
                                     , weddingName, @"Name"
                                     , self.idSong, @"IDSongDetail"
                                     , nil];
    
    [ weddingListModel insertWeding: weddingContent ];
    
    [self showModalNotification];

}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (!weddingName)
        weddingName = [[NSString alloc]init];

    weddingName = textField.text;
    
    
    if ((saveWeddingName) && (! [weddingName isEqualToString:@""]))
        [self saveWeddingName];
    
    
    [weddingListNameAlert dismissWithClickedButtonIndex:0 animated:YES];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    saveWeddingName = (buttonIndex == 1);
}

- (void) showModalNotification
{
    MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	HUD.dimBackground = YES;
	
	// Regiser for HUD callbacks so we can remove it from the window at the right time
	HUD.delegate = self;
    
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
	
    HUD.mode = MBProgressHUDModeCustomView;
    
    HUD.labelText = @"Guardado";
    
	// Show the HUD while the provided method executes in a new thread
	[HUD showWhileExecuting:@selector(finishNotification) onTarget:self withObject:nil animated:YES];
}

- (void)finishNotification {
    //El nombre de la boda DEBE SER UNICO
    //comprobar que no se ha introducido NOMBRE BODA+CANCION
    //En caso de que no exista, se introduce el nombre de la cancion para el nombre de la boda.
	sleep(1);
}


- (NSString *)GetUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge NSString *)string;
}


- (void)didPerformUnfoldActionInOverlayMenuView:(QBKOverlayMenuView *)overlaymenuView
{
    NSLog(@"Menú DESPLEGADO");
}

- (void)didPerformFoldActionInOverlayMenuView:(QBKOverlayMenuView *)overlaymenuView
{
    NSLog(@"Menú REPLEGADO");
}


@end
