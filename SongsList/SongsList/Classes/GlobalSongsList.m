//
//  GlobalSongsList.m
//  SongsList
//
//  Created by Joaquin Giraldez on 07/06/13.
//  Copyright (c) 2013 Joaquin Giraldez. All rights reserved.
//

#import "GlobalSongsList.h"
#import "DetailSongViewController.h"
#import "SongCell.h"
#import "Defines.h"
#import "SongListModel.h"
#import "AsyncImageView.h"


@interface GlobalSongsList ()
{
    NSArray *searchResults;
    
    UIImageView *background;
    
    SongListModel* songListModel;
    
    NSMutableArray *idResults;
}
@end

@implementation GlobalSongsList



-(void)viewDidLoad
{
    [self.tableView registerNib: [ UINib nibWithNibName: @"FancyCellView"
                                                 bundle: nil ]
         forCellReuseIdentifier: @"FancyCellView" ];
    
   self.navigationController.navigationBar.translucent = YES;
    
    [self initData];
    
   // self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed: @"tableBG.png"]];
       
}



- (void) initMutableArray:(NSMutableArray *) mutableArray
{
    if (!mutableArray)
        mutableArray = [[NSMutableArray alloc] init];
}


- ( void )initData
{
    if (!songListModel)
        songListModel = [[SongListModel alloc] init];
    
    
    (UIDeviceOrientationIsLandscape(self.interfaceOrientation)) ? (background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableBGLandscape.png"]]) : (background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableBG.png"]]);
    
    
    self.tableView.backgroundView = background;
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
        
    } else {
        return [songListModel getNumberOfRegisters];
    }
}

- ( CGFloat )tableView: ( UITableView* )tableView heightForRowAtIndexPath: ( NSIndexPath * )indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 50;
    }else
    {
        return 204;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FancyCellView";
    
    SongCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[SongCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }else
    {
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:cell.imageCellView];
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        NSString *titleCell = [songListModel getTitleWithId:[idResults objectAtIndex:indexPath.row]];
        cell.textLabel.text = titleCell;
        cell.textLabel.textColor = [UIColor whiteColor];
    } else {
        
        NSString *idSong = [songListModel getIDFromIndex:indexPath.row];
        
        cell.cellTitle.text =[songListModel getTitleWithId:idSong];
        cell.cellSubTitle.text = [songListModel getGroupWithId:idSong];
        NSString *ImageURL = [songListModel getImageWithId:idSong];
        NSURL *urlString = [NSURL URLWithString:ImageURL];
        
        if([urlString path] == nil) {

            cell.imageCellView.image = [UIImage imageNamed:@"labelBG.png"];

        }else
        {
            cell.imageCellView.imageURL = urlString;
        }
        
        
    }
    
    
    
    return cell;
}

- ( void )tableView: ( UITableView* )tableView didSelectRowAtIndexPath: ( NSIndexPath* )indexPath
{

    [self performSegueWithIdentifier: @"showSongsDetail" sender: self];
}


- ( void ) setDetailContentFromContent: ( NSArray* ) content
                          inDetailView: ( DetailSongViewController* )detailSongView
                             fromIndex: ( NSIndexPath* )indexPath
{
    NSString *idSong;
    
    if ([self.searchDisplayController isActive]) {
        idSong = [idResults objectAtIndex:indexPath.row];
    
    }else
    {
        idSong = [songListModel getIDFromIndex:indexPath.row];
    }
    
   
    [detailSongView setIDSong:idSong
                  setSongName:[songListModel getTitleWithId:idSong]
                 setGroupName:[songListModel getGroupWithId:idSong]
                  setVideoURL:[songListModel getVideoWithId:idSong]
     ];

}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ( [ segue.identifier isEqualToString: @"showSongsDetail" ] )
    {
        DetailSongViewController *detailSongView = segue.destinationViewController;
        
        NSIndexPath *indexPath = nil;
        
        if ([self.searchDisplayController isActive]) {
            
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            
            [ self setDetailContentFromContent: searchResults
                                  inDetailView: detailSongView
                                     fromIndex: indexPath ];
        } else {
            
            indexPath = [ self.tableView indexPathForSelectedRow ];

            [ self setDetailContentFromContent: nil
                                  inDetailView: detailSongView
                                     fromIndex: indexPath ];
        }
    }
    
}


- (void) freeMemory
{
    [idResults removeAllObjects];
    idResults = nil;

    searchResults = nil;
    songListModel = nil;
}

- (IBAction)dismissView:(id)sender
{
    [self freeMemory];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) didReceiveMemoryWarning
{
    
    [self freeMemory];
    
    [super didReceiveMemoryWarning];
}

#pragma mark Search Methods

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    // Re-style the search controller's table view
    UITableView *tableView = controller.searchResultsTableView;
    tableView.backgroundColor = [UIColor darkGrayColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSMutableArray *titlesContent = [[NSMutableArray alloc] init];
    if (idResults)
    {
        [idResults removeAllObjects];
        idResults = nil;
    }
    
    idResults = [[NSMutableArray alloc] init];
    
    for (int i = 0; i<[songListModel getNumberOfRegisters]; i++) {
        
        NSString *idSong = [songListModel getIDFromIndex:i];
        
        NSString *titleSong = [songListModel getTitleWithId:[songListModel getIDFromIndex:i]];

        if ([titleSong rangeOfString:searchText options:NSRegularExpressionSearch].location != NSNotFound)
        {
            [titlesContent addObject:titleSong];
            [idResults addObject:idSong];
        }
            
    }
    
    searchResults = titlesContent;
    
}

- ( BOOL )searchDisplayController: ( UISearchDisplayController* )controller
 shouldReloadTableForSearchString: ( NSString* )searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}


#pragma mark - Rotate method

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (UIDeviceOrientationIsLandscape(self.interfaceOrientation))
    {
        background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableBG.png"]];
    }
    else
    {
        background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableBGLandscape.png"]];
    }
    
    self.tableView.backgroundView = background;
}


@end
