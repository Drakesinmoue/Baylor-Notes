//
//  DetailViewController.h
//  Baylor Notes
//
//  Created by Sean Zhang on 1/9/13.
//  Copyright (c) 2013 Sean Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
