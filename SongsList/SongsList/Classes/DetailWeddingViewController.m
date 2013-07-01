//
//  DetailWeddingViewController.m
//  SongsList
//
//  Created by Joaquin Giraldez on 28/06/13.
//  Copyright (c) 2013 Joaquin Giraldez. All rights reserved.
//

#import "DetailWeddingViewController.h"
#import "WeddingListModel.h"
#import "SongListModel.h"

@interface DetailWeddingViewController ()
{
    IBOutlet UILabel *titleLabel;
    NSMutableArray *weddingListSongs;
}

@end

@implementation DetailWeddingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
	CGRect frame = CGRectMake(100, 0, 100, 44);
    titleLabel = [[UILabel alloc] initWithFrame:frame] ;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:@"Heiti TC" size:18.0];
    
    titleLabel.textColor = [UIColor colorWithRed:0.29 green:0.32 blue:0.32 alpha:1];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = self.nameOfWedding;
    self.navigationItem.titleView = titleLabel;
    
    

	if (arrayOfItems == nil) {
		
		
		
		arrayOfItems = [NSMutableArray  new];
		
		
	}
    
    [self getNameOfSongsFromListWedding];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[self.tableView flashScrollIndicators];
}


- (void) getNameOfSongsFromListWedding
{
    
    WeddingListModel *weddingList = [[WeddingListModel alloc] init];
    
    SongListModel *songList = [[SongListModel alloc] init];
    
    weddingListSongs = [NSMutableArray new];
    
    weddingListSongs = [weddingList getTheSongsFormListWedding:self.nameOfWedding];
    
    for(int i=0; i<[weddingListSongs count]; i++)
    {
        NSString * songName = [songList getTitleWithId:[weddingListSongs objectAtIndex:i]];
        
        [arrayOfItems addObject:songName];
    }
    
}

#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	/*
     Disable reordering if there's one or zero items.
     For this example, of course, this will always be YES.
	 */
	[self setReorderingEnabled:( arrayOfItems.count > 1 )];
	
	return arrayOfItems.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
	cell.textLabel.text = [arrayOfItems objectAtIndex:indexPath.row];
	
    return cell;
}

// should be identical to cell returned in -tableView:cellForRowAtIndexPath:
- (UITableViewCell *)cellIdenticalToCellAtIndexPath:(NSIndexPath *)indexPath forDragTableViewController:(ATSDragToReorderTableViewController *)dragTableViewController {
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
	cell.textLabel.text = [arrayOfItems objectAtIndex:indexPath.row];
	
	return cell;
}

/*
 Required for drag tableview controller
 */
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	
	NSString *itemToMove = [arrayOfItems objectAtIndex:fromIndexPath.row];
	[arrayOfItems removeObjectAtIndex:fromIndexPath.row];
	[arrayOfItems insertObject:itemToMove atIndex:toIndexPath.row];
    
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    self.nameOfWedding = nil;
    
    
}



@end

