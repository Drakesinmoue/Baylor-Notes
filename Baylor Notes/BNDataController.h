//
//  BNDataController.h
//  BaylorNotes10
//
//  Created by Sean Zhang on 11/8/12.
//  Copyright (c) 2012 Sean Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BNAuthorGetter;

@interface BNDataController : NSObject <NSXMLParserDelegate> {
    NSXMLParser *parser;
    NSMutableDictionary *item;
    NSString *currentElement;
    NSMutableString *currentTitle, *currentDate, *currentSummary, *currentLink, *currentSummaryTableCell;
@private
    BOOL done;
}

@property (copy, nonatomic) NSMutableArray *newsItems;
@property (strong, nonatomic) BNAuthorGetter *authorGetter;

- (NSUInteger)countOfList;
- (id)objectInListAtIndex:(NSUInteger)theIndex;
- (void) updateObject: (id) obj inListAtIndex:(NSUInteger)theIndex;
- (void) parseURL;
@end


