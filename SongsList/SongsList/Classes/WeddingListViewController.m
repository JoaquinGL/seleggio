//
//  DKMainViewController.m
//  LiveBlur
//
//  Created by Dmitry Klimkin on 16/6/13.
//  Copyright (c) 2013 Dmitry Klimkin. All rights reserved.
//

#import "WeddingListViewController.h"
#import "DKLiveBlurView.h"
#import "WeddingListModel.h"
#import "DetailWeddingViewController.h"

#define kDKTableViewMainBackgroundImageFileName @"ListadoBG.png"

@interface WeddingListViewController()
{
    WeddingListModel *weddingListModel;
    DKLiveBlurView *backgroundView;
    IBOutlet UITableViewCell *cell;
}

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *items;

@end

@implementation WeddingListViewController

@synthesize tableView = _tableView;
@synthesize items = _items;

- (id)init {
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSMutableArray *)itemsFiltered {
    
    NSMutableArray *_itemsFiltered = nil;
    
    if (_items == nil) {
        _items = [NSMutableArray new];
        
        if (!weddingListModel)
            weddingListModel = [[WeddingListModel alloc] init];
        
        for(int i=0; i<[weddingListModel getNumberOfRegisters]; i++)
        {
            //[_items addObject:[weddingListModel getIDFromIndex:i]];
            
            id idWedding = [weddingListModel getIDFromIndex:i];
            
            NSString *nameOfWedding = [weddingListModel getNameFromIDWedding:idWedding];
            
           
            [_items addObject:nameOfWedding];
            
        }
       
    }
    
    _itemsFiltered = [NSMutableArray new];
    
    [_itemsFiltered setArray:[[NSSet setWithArray:_items] allObjects]];
    
    
    return _itemsFiltered;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"Listado de Bodas", nil);
    self.navigationItem.title = self.title;
    self.navigationController.navigationBar.translucent = YES;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed: kDKTableViewMainBackgroundImageFileName]];
    
    if ( !self.tableView )
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    backgroundView = [[DKLiveBlurView alloc] initWithFrame: self.view.bounds];
    
    backgroundView.originalImage = [UIImage imageNamed:kDKTableViewMainBackgroundImageFileName];
    backgroundView.tableView = self.tableView;
    backgroundView.isGlassEffectOn = YES;
    
    self.tableView.backgroundView = backgroundView;
    
    [self.view addSubview: self.tableView];
    
    if (!weddingListModel)
        weddingListModel = [[WeddingListModel alloc] init];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > 1) {
        return 50.0f;
    } else {
        return 200.0f;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    int number = [[self itemsFiltered] count];
    
    return number + 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    
    if (indexPath.row > 1) {
        NSString *weddingName = [[self itemsFiltered] objectAtIndex:indexPath.row - 2];
        
        cell.textLabel.text = weddingName;
    } else {
        cell.textLabel.text = @"";
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}


- ( void )tableView: ( UITableView* )tableView didSelectRowAtIndexPath: ( NSIndexPath* )indexPath
{
    //NSString *idSong;
    
    if (indexPath.row >1)
    {
        NSString *weddingName = [[self itemsFiltered] objectAtIndex:indexPath.row - 2];
        
        DetailWeddingViewController *detailViewController = [[DetailWeddingViewController alloc] init];
        
        detailViewController.nameOfWedding = weddingName;
        
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    
}


- (IBAction)dismissView:(id)sender
{
    weddingListModel = nil;
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
    self.tableView = nil;
    backgroundView.tableView = nil;
    backgroundView = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
