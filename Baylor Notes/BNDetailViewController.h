//
//  BNDetailViewController.h
//  BaylorNotes10
//
//  Created by Sean Zhang on 11/8/12.
//  Copyright (c) 2012 Sean Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNDetailViewController : UIViewController <UISplitViewControllerDelegate, UIWebViewDelegate>
@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *instructionLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIWebView *BNWebView;

@end
