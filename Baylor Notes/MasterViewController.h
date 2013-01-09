//
//  MasterViewController.h
//  Baylor Notes
//
//  Created by Sean Zhang on 1/9/13.
//  Copyright (c) 2013 Sean Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
