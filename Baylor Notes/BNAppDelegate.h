//
//  BNAppDelegate.h
//  BaylorNotes10
//
//  Created by Sean Zhang on 11/8/12.
//  Copyright (c) 2012 Sean Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNDataController.h"

@interface BNAppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (copy, nonatomic) BNDataController *dataController;
@end

