//
//  BNMasterViewController.m
//  BaylorNotes10
//
//  Created by Sean Zhang on 11/8/12.
//  Copyright (c) 2012 Sean Zhang. All rights reserved.
//

#import "BNMasterViewController.h"
#import "BNDetailViewController.h"
#import "BNDataController.h"
#import "BNAuthorGetter.h"

#define ShowNetworkActivityIndicator() [UIApplication sharedApplication].networkActivityIndicatorVisible = YES
#define HideNetworkActivityIndicator() [UIApplication sharedApplication].networkActivityIndicatorVisible = NO



@implementation BNMasterViewController
- (void)awakeFromNib
{
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    
    [super awakeFromNib];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Loading...";
	// Do any additional setup after loading the view, typically from a nib.
    self.dataController = [[BNDataController alloc] init];
    self.detailViewController = (BNDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
   // self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1];
    self.navigationController.navigationBar.backgroundColor = [UIColor redColor];

    [self.dataController parseURL];
    [self.tableView reloadData];
    ShowNetworkActivityIndicator();
    
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog( @"Story count: %i", [_dataController countOfList] );
    return [self.dataController countOfList];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"table view cell loading");
    static NSString *CellIdentifier = @"NewsItemCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSMutableDictionary *tmpItem = [self.dataController objectInListAtIndex:indexPath.row];
    [cell setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1.0]];
    self.title = @"Articles";
    
    //CELL TITLES
    [[cell textLabel] setText:tmpItem[@"title"]];
    //[[cell textLabel]setFont:[UIFont fontWithName:@"" size:10]];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    
    //CELL DESCRIPTIONS
    [[cell detailTextLabel]setText:tmpItem[@"summaryCell"]];
    //[[cell detailTextLabel]setFont:[UIFont fontWithName:@"Helvetica Neue Light" size:10]];
    [cell.detailTextLabel setTextColor:[UIColor whiteColor]];
    HideNetworkActivityIndicator();
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *tmpItem = [self.dataController objectInListAtIndex:indexPath.row];
    NSMutableString *htmlString = [NSMutableString stringWithFormat:@"<div style=\"font: 20pt/35pt Times New Roman, serif;\">%@</div>", tmpItem[@"summary"]];
    
    //format titleView
    self.detailViewController.titleView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    self.detailViewController.titleLabel.textColor = [UIColor colorWithWhite:1 alpha:1];
    self.detailViewController.authorLabel.textColor = [UIColor colorWithWhite:0.425 alpha:1];
    
    //remove labels
    self.detailViewController.welcomeLabel.hidden = YES;
    self.detailViewController.instructionLabel.hidden = YES;
    
    self.detailViewController.titleLabel.text = @"Loading Article...";
    self.detailViewController.authorLabel.text = nil;
    //to facilitate going from article to article
    self.detailViewController.BNWebView.hidden = NO;
    [self.detailViewController.BNWebView loadHTMLString:@"" baseURL:nil];
    
    


    if( [tmpItem[@"creator"] isEqualToString:@"none"] )
    {
        BNAuthorGetter *ag = [[BNAuthorGetter alloc] initWithURL:[NSURL URLWithString:[tmpItem[@"link"]  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
        [ag fetchAuthor];
        
        NSMutableDictionary *item = [[NSMutableDictionary alloc] initWithDictionary:tmpItem];
        [item removeObjectForKey:@"creator"];
        item[@"creator"] = ag.author;
        [self.dataController updateObject:item inListAtIndex:indexPath.row];
        self.detailViewController.authorLabel.text = ag.author;
        
    }
    else
    {
        self.detailViewController.authorLabel.text = tmpItem[@"creator"];
    }
    self.detailViewController.titleLabel.text = tmpItem[@"title"];
    [self.detailViewController.BNWebView loadHTMLString:htmlString baseURL:nil];
    self.detailViewController.BNWebView.delegate = self.detailViewController;
 
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end


