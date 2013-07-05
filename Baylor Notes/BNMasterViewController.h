//
//  BNMasterViewController.h
//  BaylorNotes10
//
//  Created by Sean Zhang on 11/8/12.
//  Copyright (c) 2012 Sean Zhang. All rights reserved.
//
#import <UIKit/UIKit.h>

@class BNDetailViewController;
@class BNDataController;

@interface BNMasterViewController : UITableViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) BNDetailViewController *detailViewController;
@property (strong, nonatomic) BNDataController *dataController;
@end
