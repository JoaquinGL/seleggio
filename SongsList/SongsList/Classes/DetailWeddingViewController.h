//
//  DetailWeddingViewController.h
//  SongsList
//
//  Created by Joaquin Giraldez on 28/06/13.
//  Copyright (c) 2013 Joaquin Giraldez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATSDragToReorderTableViewController.h"

@interface DetailWeddingViewController : ATSDragToReorderTableViewController<UITableViewDelegate>
{
    NSMutableArray *arrayOfItems;
    NSString *nameOfWedding_;
}

@property (nonatomic, retain) NSString * nameOfWedding;

@end
