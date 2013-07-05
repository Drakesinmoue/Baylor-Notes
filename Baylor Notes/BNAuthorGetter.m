//
//  BNAuthorGetter.m
//  Baylor Notes
//
//  Created by Sean Zhang on 1/29/13.
//  Copyright (c) 2013 Sean Zhang. All rights reserved.
//

#import "BNAuthorGetter.h"
#import "BNDataController.h"
#import "XPathQuery.h"


@implementation BNAuthorGetter

- (id) initWithURL:(NSURL *) URL
{
    self = [super init];
    if( self )
    {
        _baseURL = URL;
        _responseData = [NSMutableData data];
        _author = @"none";
        done = NO;
    }
    return self;
}

- (void) fetchAuthor
{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:_baseURL];
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (_connection != nil) {
        do {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        } while (!done);
    }
}

//in case link redirects 
- (NSURLRequest *)connection:(NSURLConnection *)connection
             willSendRequest:(NSURLRequest *)request
            redirectResponse:(NSURLResponse *)redirectResponse
{
    _baseURL = [request URL];
    return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [_responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"connection error: %@", [connection currentRequest] );
    done = YES;
    /*
    UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:[error localizedDescription]  delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil ];
    [errorView show];*/
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *xpathQueryString = @"//a[@property='dc:creator']";
    NSArray *namesArray = PerformHTMLXPathQuery(_responseData, xpathQueryString);
    _author = namesArray[0][@"nodeContent"];
    done = YES;
}

@end
