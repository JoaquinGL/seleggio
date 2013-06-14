//
//  SongCell.h
//  SongsList
//
//  Created by Joaquin Giraldez on 10/06/13.
//  Copyright (c) 2013 Joaquin Giraldez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SongCell : UITableViewCell
{
    UILabel* cellTitle_;
    UILabel* cellSubTitle_;
    
    UIImageView * imageCellView_;
    
}

@property(nonatomic, retain) IBOutlet UILabel* cellTitle;
@property(nonatomic, retain) IBOutlet UILabel* cellSubTitle;
@property(nonatomic, retain) IBOutlet UIImageView* imageCellView;


@end
