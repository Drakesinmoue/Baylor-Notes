//
//  BNAuthorGetter.h
//  Baylor Notes
//
//  Created by Sean Zhang on 1/29/13.
//  Copyright (c) 2013 Sean Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNAuthorGetter : NSObject <NSURLConnectionDelegate> {
@private
    BOOL done;
}
@property (readwrite, nonatomic) NSMutableData *responseData;
@property (readwrite, nonatomic)  NSURL *baseURL;
@property (readwrite, nonatomic) NSString *author;
@property (readwrite, nonatomic) NSURLConnection* connection;
- (id) initWithURL: (NSURL *) URL;
- (void) fetchAuthor;

@end
