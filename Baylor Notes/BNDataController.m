//
//  BNDataController.m
//  BaylorNotes10
//
//  Created by Sean Zhang on 11/8/12.
//  Copyright (c) 2012 Sean Zhang. All rights reserved.
//

#import "BNDataController.h"
#import "BNDetailViewController.h"
#import "BNAuthorGetter.h"

@implementation BNDataController
- (id) init
{
    if( self = [super init] )
    {
        _newsItems = [NSMutableArray array];
        done = NO;
        return self;
    }
    return nil;
}

-(void) parseXMLFileAtURL:(NSString *)URL
{
	NSURL *feedURL = [NSURL URLWithString:URL];
    parser = [[NSXMLParser alloc] initWithContentsOfURL:feedURL];
    
    [parser setDelegate:self];
    
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
        do {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        } while (!done);
}

- (void) parseURL
{
    [self parseXMLFileAtURL:@"http://www.baylornotes.org/rss/articles/all"];
}

- (NSUInteger)countOfList {
    NSLog(@"Count: %i", [_newsItems count]);
    return [_newsItems count];
}

- (id)objectInListAtIndex:(NSUInteger)theIndex {
    return _newsItems[theIndex];
}

- (void) updateObject: (id) obj inListAtIndex:(NSUInteger)theIndex
{
    [_newsItems setObject:obj atIndexedSubscript:theIndex];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
/*    NSString * errorString = [NSString stringWithFormat:@"Unable to download story feed from web site (Error code %i )",[parseError code]];
    NSLog(@"error parsing XML: %@", errorString);
    UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Error loading content" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];*/
    done = YES;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    currentElement = [elementName copy];
    if ([elementName isEqualToString:@"item"]) {
        // clear out our story item caches...
        item = [[NSMutableDictionary alloc] init];
        currentTitle = [[NSMutableString alloc] init];
        currentDate = [[NSMutableString alloc] init];
        currentSummary = [[NSMutableString alloc] init];
        currentLink = [[NSMutableString alloc] init];
        currentSummaryTableCell = [[NSMutableString alloc]init];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    //NSLog(@"ended element: %@", elementName);
    if ([elementName isEqualToString:@"item"]) {

        currentSummaryTableCell = [self stringByStrippingHTML:currentSummary];
        // save values to an item, then store that item into the array...
        item[@"title"] = currentTitle;
        item[@"link"] = currentLink;
        item[@"summary"] = currentSummary;
        item[@"date"] = currentDate;
        item[@"summaryCell"] = currentSummaryTableCell;
        item[@"creator"] = @"none";
/*
        BNAuthorGetter *ag = [[BNAuthorGetter alloc] initWithURL:[NSURL URLWithString:[currentLink stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
        [ag fetchAuthor];
        [item setObject:ag.author forKey:@"creator"];
*/        
        [_newsItems addObject:[item copy]];
        //NSLog(@"adding story: %@", currentTitle);
    }
    
}

//puts string data into each element
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if ([currentElement isEqualToString:@"title"]) {
        [currentTitle appendString:string];
    } else if ([currentElement isEqualToString:@"link"]) {
        [currentLink appendString:string];
    } else if ([currentElement isEqualToString:@"description"]) {
        [currentSummary appendString:string];
        [currentSummaryTableCell appendString:string]; 
    } else if ([currentElement isEqualToString:@"pubDate"]) {
        [currentDate appendString:string];
    }
}


//to remove HTML tags
- (NSMutableString *) stringByStrippingHTML:(NSString *)s {
    s = [s stringByReplacingOccurrencesOfString:@"<p>"
                                     withString:@""];
    s = [s stringByReplacingOccurrencesOfString:@"</p>"
                                     withString:@"\n"];
    s = [s stringByReplacingOccurrencesOfString:@"&quot;"
                                     withString:@"\""];
    s = [s stringByReplacingOccurrencesOfString:@"<br>"
                                     withString:@"\n"];
    s = [s stringByReplacingOccurrencesOfString:@"<br />"
                                     withString:@"\n"];
    s = [s stringByReplacingOccurrencesOfString:@"&nbsp;"
                                     withString:@" "];
    s = [s stringByReplacingOccurrencesOfString:@"&lsquo;"
                                     withString:@"‘"];
    s = [s stringByReplacingOccurrencesOfString:@"&rdquo;"
                                     withString:@"\""];
    s = [s stringByReplacingOccurrencesOfString:@"&ldquo;"
                                     withString:@"\""];
    s = [s stringByReplacingOccurrencesOfString:@"</a>"
                                     withString:@""];
    s = [s stringByReplacingOccurrencesOfString:@"<a href=\""
                                     withString:@""];
    s = [s stringByReplacingOccurrencesOfString:@"\">"
                                     withString:@""];
    s = [s stringByReplacingOccurrencesOfString:@"<strong>"
                                     withString:@""];
    s = [s stringByReplacingOccurrencesOfString:@"</strong>"
                                     withString:@""];
    s = [s stringByReplacingOccurrencesOfString:@"&quot;"
                                     withString:@"\""];
    s = [s stringByReplacingOccurrencesOfString:@"<em>"
                                     withString:@" "];
    s = [s stringByReplacingOccurrencesOfString:@"</em>"
                                     withString:@""];
    s = [s stringByReplacingOccurrencesOfString:@"&sbquo;"
                                     withString:@"‚"];
    s = [s stringByReplacingOccurrencesOfString:@"&bdquo;"
                                     withString:@"„"];
    s = [s stringByReplacingOccurrencesOfString:@"&dagger;"
                                     withString:@"†"];
    s = [s stringByReplacingOccurrencesOfString:@"&Dagger;"
                                     withString:@"‡"];
    s = [s stringByReplacingOccurrencesOfString:@"&permil"
                                     withString:@"‰"];
    s = [s stringByReplacingOccurrencesOfString:@"&lsquo;"
                                     withString:@"‹"];
    s = [s stringByReplacingOccurrencesOfString:@"&rsquo;"
                                     withString:@"'"];
    s = [s stringByReplacingOccurrencesOfString:@"&spades;"
                                     withString:@"♠"];
    s = [s stringByReplacingOccurrencesOfString:@"&clubs;"
                                     withString:@"♣"];
    s = [s stringByReplacingOccurrencesOfString:@"&hearts;"
                                     withString:@"♥"];
    s = [s stringByReplacingOccurrencesOfString:@"&diams;"
                                     withString:@"♦"];
    s = [s stringByReplacingOccurrencesOfString:@"&oline;"
                                     withString:@"‾"];
    s = [s stringByReplacingOccurrencesOfString:@"&larr"
                                     withString:@"←"];
    s = [s stringByReplacingOccurrencesOfString:@"&uarr;"
                                     withString:@"↑"];
    s = [s stringByReplacingOccurrencesOfString:@"&rarr;"
                                     withString:@"→"];
    s = [s stringByReplacingOccurrencesOfString:@"&darr;"
                                     withString:@"↓"];
    s = [s stringByReplacingOccurrencesOfString:@"&#x2122;"
                                     withString:@"™"];
    s = [s stringByReplacingOccurrencesOfString:@"&trade;"
                                     withString:@"™"];
    s = [s stringByReplacingOccurrencesOfString:@"&#09;"
                                     withString:@"  "];
    s = [s stringByReplacingOccurrencesOfString:@"&#10;"
                                     withString:@"\n"];
    s = [s stringByReplacingOccurrencesOfString:@"&#32;"
                                     withString:@" "];
    s = [s stringByReplacingOccurrencesOfString:@"&#33;"
                                     withString:@"!"];
    s = [s stringByReplacingOccurrencesOfString:@"&#34;"
                                     withString:@"\""];
    s = [s stringByReplacingOccurrencesOfString:@"&#35;"
                                     withString:@"#"];
    s = [s stringByReplacingOccurrencesOfString:@"&#36"
                                     withString:@"$"];
    s = [s stringByReplacingOccurrencesOfString:@"&#37;"
                                     withString:@"%"];
    s = [s stringByReplacingOccurrencesOfString:@"&#38;"
                                     withString:@"&"];
    s = [s stringByReplacingOccurrencesOfString:@"&#39;"
                                     withString:@"'"];
    s = [s stringByReplacingOccurrencesOfString:@"&#40;"
                                     withString:@"("];
    s = [s stringByReplacingOccurrencesOfString:@"&#41;"
                                     withString:@")"];
    s = [s stringByReplacingOccurrencesOfString:@"&#42;"
                                     withString:@"*"];
    s = [s stringByReplacingOccurrencesOfString:@"&#43;"
                                     withString:@"+"];
    s = [s stringByReplacingOccurrencesOfString:@"#44;"
                                     withString:@","];
    s = [s stringByReplacingOccurrencesOfString:@"&#45;"
                                     withString:@"-"];
    s = [s stringByReplacingOccurrencesOfString:@"&#46;"
                                     withString:@"."];
    s = [s stringByReplacingOccurrencesOfString:@"&#47;"
                                     withString:@"/"];
    s = [s stringByReplacingOccurrencesOfString:@"&frasl"
                                     withString:@"/"];
    s = [s stringByReplacingOccurrencesOfString:@"&#48"
                                     withString:@"0"];
    s = [s stringByReplacingOccurrencesOfString:@"&#49;"
                                     withString:@"1"];
    s = [s stringByReplacingOccurrencesOfString:@"&#50;"
                                     withString:@"2"];
    s = [s stringByReplacingOccurrencesOfString:@"&#51;"
                                     withString:@"3"];
    s = [s stringByReplacingOccurrencesOfString:@"&#52;"
                                     withString:@"4"];
    s = [s stringByReplacingOccurrencesOfString:@"&#53;"
                                     withString:@"5"];
    s = [s stringByReplacingOccurrencesOfString:@"&#54;"
                                     withString:@"6"];
    s = [s stringByReplacingOccurrencesOfString:@"&#55;"
                                     withString:@"7"];
    s = [s stringByReplacingOccurrencesOfString:@"&#56;"
                                     withString:@"8"];
    s = [s stringByReplacingOccurrencesOfString:@"&#57;"
                                     withString:@"9"];
    s = [s stringByReplacingOccurrencesOfString:@"&#58;"
                                     withString:@":"];
    s = [s stringByReplacingOccurrencesOfString:@"&#59;"
                                     withString:@";"];
    s = [s stringByReplacingOccurrencesOfString:@"&#60;"
                                     withString:@"<"];
    s = [s stringByReplacingOccurrencesOfString:@"&#61;"
                                     withString:@"="];
    s = [s stringByReplacingOccurrencesOfString:@"&#62;"
                                     withString:@">"];
    s = [s stringByReplacingOccurrencesOfString:@"&#63;"
                                     withString:@"?"];
    s = [s stringByReplacingOccurrencesOfString:@"&#64;"
                                     withString:@"@"];
    s = [s stringByReplacingOccurrencesOfString:@"&#91;"
                                     withString:@"["];
    s = [s stringByReplacingOccurrencesOfString:@"&#92;"
                                     withString:@"\\"];
    s = [s stringByReplacingOccurrencesOfString:@"&#94;"
                                     withString:@"^"];
    s = [s stringByReplacingOccurrencesOfString:@"&#95;"
                                     withString:@"_"];
    s = [s stringByReplacingOccurrencesOfString:@"&#96;"
                                     withString:@"`"];
    s = [s stringByReplacingOccurrencesOfString:@"&#123;"
                                     withString:@"{"];
    s = [s stringByReplacingOccurrencesOfString:@"&#124;"
                                     withString:@"|"];
    s = [s stringByReplacingOccurrencesOfString:@"&#125;"
                                     withString:@"}"];
    s = [s stringByReplacingOccurrencesOfString:@"&#126;"
                                     withString:@"~"];
    s = [s stringByReplacingOccurrencesOfString:@"&#133;"
                                     withString:@"…"];
    s = [s stringByReplacingOccurrencesOfString:@"&hellip;"
                                     withString:@"…"];
    s = [s stringByReplacingOccurrencesOfString:@"&#150;"
                                     withString:@"–"];
    s = [s stringByReplacingOccurrencesOfString:@"&ndash;"
                                     withString:@"–"];
    s = [s stringByReplacingOccurrencesOfString:@"&#151;"
                                     withString:@"—"];
    s = [s stringByReplacingOccurrencesOfString:@"&mdash;"
                                     withString:@"—"];
    s = [s stringByReplacingOccurrencesOfString:@"&#160;"
                                     withString:@" "];
    s = [s stringByReplacingOccurrencesOfString:@"&#161;"
                                     withString:@"¡"];
    s = [s stringByReplacingOccurrencesOfString:@"&iexcl;"
                                     withString:@"¡"];
    s = [s stringByReplacingOccurrencesOfString:@"&#162;"
                                     withString:@"¢"];
    s = [s stringByReplacingOccurrencesOfString:@"&cent;"
                                     withString:@"¢"];
    s = [s stringByReplacingOccurrencesOfString:@"&#163;"
                                     withString:@"£"];
    s = [s stringByReplacingOccurrencesOfString:@"&pound;"
                                     withString:@"£"];
    s = [s stringByReplacingOccurrencesOfString:@"&#164;"
                                     withString:@"¤"];
    s = [s stringByReplacingOccurrencesOfString:@"&curren;"
                                     withString:@"¤"];
    s = [s stringByReplacingOccurrencesOfString:@"&#165;"
                                     withString:@"¥"];
    s = [s stringByReplacingOccurrencesOfString:@"&yen;"
                                     withString:@"¥"];
    s = [s stringByReplacingOccurrencesOfString:@"&#166;"
                                     withString:@"¦"];
    s = [s stringByReplacingOccurrencesOfString:@"&brvbar;"
                                     withString:@"¦"];
    s = [s stringByReplacingOccurrencesOfString:@"&brkbar;"
                                     withString:@"¦"];
    s = [s stringByReplacingOccurrencesOfString:@"&#167;"
                                     withString:@"§"];
    s = [s stringByReplacingOccurrencesOfString:@"&sect;"
                                     withString:@"§"];
    s = [s stringByReplacingOccurrencesOfString:@"&#168;"
                                     withString:@"¨"];
    s = [s stringByReplacingOccurrencesOfString:@"&uml;"
                                     withString:@"¨"];
    s = [s stringByReplacingOccurrencesOfString:@"&die;"
                                     withString:@"¨"];
    s = [s stringByReplacingOccurrencesOfString:@"&#169;"
                                     withString:@"©"];
    s = [s stringByReplacingOccurrencesOfString:@"&copy;"
                                     withString:@"©"];
    s = [s stringByReplacingOccurrencesOfString:@"&#170;"
                                     withString:@"ª"];
    s = [s stringByReplacingOccurrencesOfString:@"&ordf;"
                                     withString:@"ª"];
    s = [s stringByReplacingOccurrencesOfString:@"&#171;"
                                     withString:@"«"];
    s = [s stringByReplacingOccurrencesOfString:@"&laquo;"
                                     withString:@"«"];
    s = [s stringByReplacingOccurrencesOfString:@"&#172;"
                                     withString:@"¬"];
    s = [s stringByReplacingOccurrencesOfString:@"&not;"
                                     withString:@"¬"];
    s = [s stringByReplacingOccurrencesOfString:@"&#173;"
                                     withString:@""];
    s = [s stringByReplacingOccurrencesOfString:@"&shy;"
                                     withString:@""];
    s = [s stringByReplacingOccurrencesOfString:@"&#174;"
                                     withString:@"®"];
    s = [s stringByReplacingOccurrencesOfString:@"&reg;"
                                     withString:@"®"];
    s = [s stringByReplacingOccurrencesOfString:@"&#175;"
                                     withString:@"¯"];
    s = [s stringByReplacingOccurrencesOfString:@"&macr;"
                                     withString:@"¯"];
    s = [s stringByReplacingOccurrencesOfString:@"&hibar;"
                                     withString:@"¯"];
    s = [s stringByReplacingOccurrencesOfString:@"&#176;"
                                     withString:@"°"];
    s = [s stringByReplacingOccurrencesOfString:@"&deg;"
                                     withString:@"°"];
    s = [s stringByReplacingOccurrencesOfString:@"&#177;"
                                     withString:@"±"];
    s = [s stringByReplacingOccurrencesOfString:@"&plusmn;"
                                     withString:@"±"];
    s = [s stringByReplacingOccurrencesOfString:@"&#178;"
                                     withString:@"²"];
    s = [s stringByReplacingOccurrencesOfString:@"&sup2;"
                                     withString:@"²"];
    s = [s stringByReplacingOccurrencesOfString:@"&#179;"
                                     withString:@"³"];
    s = [s stringByReplacingOccurrencesOfString:@"&sup3;"
                                     withString:@"³"];
    s = [s stringByReplacingOccurrencesOfString:@"&#180;"
                                     withString:@"´"];
    s = [s stringByReplacingOccurrencesOfString:@"&acute;"
                                     withString:@"´"];
    s = [s stringByReplacingOccurrencesOfString:@"&#181;"
                                     withString:@"µ"];
    s = [s stringByReplacingOccurrencesOfString:@"&micro;"
                                     withString:@"µ"];
    s = [s stringByReplacingOccurrencesOfString:@"&#182;"
                                     withString:@"¶"];
    s = [s stringByReplacingOccurrencesOfString:@"&para;"
                                     withString:@"¶"];
    s = [s stringByReplacingOccurrencesOfString:@"&#183;"
                                     withString:@"·"];
    s = [s stringByReplacingOccurrencesOfString:@"&middot;"
                                     withString:@"·"];
    s = [s stringByReplacingOccurrencesOfString:@"&#184;"
                                     withString:@"¸"];
    s = [s stringByReplacingOccurrencesOfString:@"&cedil;"
                                     withString:@"¸"];
    s = [s stringByReplacingOccurrencesOfString:@"&#185;"
                                     withString:@"¹"];
    s = [s stringByReplacingOccurrencesOfString:@"&sup1;"
                                     withString:@"¹"];
    s = [s stringByReplacingOccurrencesOfString:@"&#186;"
                                     withString:@"º"];
    s = [s stringByReplacingOccurrencesOfString:@"&ordm;"
                                     withString:@"º"];
    s = [s stringByReplacingOccurrencesOfString:@"&#187;"
                                     withString:@"»"];
    s = [s stringByReplacingOccurrencesOfString:@"&raquo;"
                                     withString:@"»"];
    s = [s stringByReplacingOccurrencesOfString:@"&#188;"
                                     withString:@"¼"];
    s = [s stringByReplacingOccurrencesOfString:@"&frac14;"
                                     withString:@"¼"];
    s = [s stringByReplacingOccurrencesOfString:@"&#189;"
                                     withString:@"½"];
    s = [s stringByReplacingOccurrencesOfString:@"&frac12;"
                                     withString:@"½"];
    s = [s stringByReplacingOccurrencesOfString:@"&#190;"
                                     withString:@"¾"];
    s = [s stringByReplacingOccurrencesOfString:@"&frac34;"
                                     withString:@"¾"];
    s = [s stringByReplacingOccurrencesOfString:@"&#191;"
                                     withString:@"¿"];
    s = [s stringByReplacingOccurrencesOfString:@"&iquest;"
                                     withString:@"¿"];
    s = [s stringByReplacingOccurrencesOfString:@"&#192;"
                                     withString:@"À"];
    s = [s stringByReplacingOccurrencesOfString:@"&Agrave;"
                                     withString:@"À"];
    s = [s stringByReplacingOccurrencesOfString:@"&#193;"
                                     withString:@"Á"];
    s = [s stringByReplacingOccurrencesOfString:@"&Aacute;"
                                     withString:@"Á"];
    s = [s stringByReplacingOccurrencesOfString:@"&#194;"
                                     withString:@"Â"];
    s = [s stringByReplacingOccurrencesOfString:@"&Acirc;"
                                     withString:@"Â"];
    s = [s stringByReplacingOccurrencesOfString:@"&#195;"
                                     withString:@"Ã"];
    s = [s stringByReplacingOccurrencesOfString:@"&Atilde;"
                                     withString:@"Ã"];
    s = [s stringByReplacingOccurrencesOfString:@"&#196;"
                                     withString:@"Ä"];
    s = [s stringByReplacingOccurrencesOfString:@"&Auml;"
                                     withString:@"Ä"];
    s = [s stringByReplacingOccurrencesOfString:@"&#197;"
                                     withString:@"Å"];
    s = [s stringByReplacingOccurrencesOfString:@"&Aring;"
                                     withString:@"Å"];
    s = [s stringByReplacingOccurrencesOfString:@"&#198;"
                                     withString:@"Æ"];
    s = [s stringByReplacingOccurrencesOfString:@"&AElig;"
                                     withString:@"Æ"];
    s = [s stringByReplacingOccurrencesOfString:@"&#199;"
                                     withString:@"Ç"];
    s = [s stringByReplacingOccurrencesOfString:@"&Ccedil;"
                                     withString:@"Ç"];
    s = [s stringByReplacingOccurrencesOfString:@"&#200;"
                                     withString:@"È"];
    s = [s stringByReplacingOccurrencesOfString:@"&Egrave;"
                                     withString:@"È"];
    s = [s stringByReplacingOccurrencesOfString:@"&#201;"
                                     withString:@"É"];
    s = [s stringByReplacingOccurrencesOfString:@"&Eacute;"
                                     withString:@"É"];
    s = [s stringByReplacingOccurrencesOfString:@"&#202;"
                                     withString:@"Ê"];
    s = [s stringByReplacingOccurrencesOfString:@"&Ecirc;"
                                     withString:@"Ê"];
    s = [s stringByReplacingOccurrencesOfString:@"&#203;"
                                     withString:@"Ë"];
    s = [s stringByReplacingOccurrencesOfString:@"&Euml;"
                                     withString:@"Ë"];
    s = [s stringByReplacingOccurrencesOfString:@"&#204;"
                                     withString:@"Ì"];
    s = [s stringByReplacingOccurrencesOfString:@"&Igrave;"
                                     withString:@"Ì"];
    s = [s stringByReplacingOccurrencesOfString:@"&#205;"
                                     withString:@"Í"];
    s = [s stringByReplacingOccurrencesOfString:@"&Iacute;"
                                     withString:@"Í"];
    s = [s stringByReplacingOccurrencesOfString:@"&#206;"
                                     withString:@"Î"];
    s = [s stringByReplacingOccurrencesOfString:@"&Icirc;"
                                     withString:@"Î"];
    s = [s stringByReplacingOccurrencesOfString:@"&#207;"
                                     withString:@"Ï"];
    s = [s stringByReplacingOccurrencesOfString:@"&Iuml;"
                                     withString:@"Ï"];
    s = [s stringByReplacingOccurrencesOfString:@"&#208;"
                                     withString:@"Ð"];
    s = [s stringByReplacingOccurrencesOfString:@"&ETH;"
                                     withString:@"Ð"];
    s = [s stringByReplacingOccurrencesOfString:@"&#209;"
                                     withString:@"Ñ"];
    s = [s stringByReplacingOccurrencesOfString:@"&Ntilde;"
                                     withString:@"Ñ"];
    s = [s stringByReplacingOccurrencesOfString:@"&#210;"
                                     withString:@"Ò"];
    s = [s stringByReplacingOccurrencesOfString:@"&Ograve;"
                                     withString:@"Ò"];
    s = [s stringByReplacingOccurrencesOfString:@"&#211;"
                                     withString:@"Ó"];
    s = [s stringByReplacingOccurrencesOfString:@"&Oacute;"
                                     withString:@"Ó"];
    s = [s stringByReplacingOccurrencesOfString:@"&#212;"
                                     withString:@"Ô"];
    s = [s stringByReplacingOccurrencesOfString:@"&Ocirc;"
                                     withString:@"Ô"];
    s = [s stringByReplacingOccurrencesOfString:@"&#213;"
                                     withString:@"Õ"];
    s = [s stringByReplacingOccurrencesOfString:@"&Otilde;"
                                     withString:@"Õ"];
    s = [s stringByReplacingOccurrencesOfString:@"&#214;"
                                     withString:@"Ö"];
    s = [s stringByReplacingOccurrencesOfString:@"&Ouml;"
                                     withString:@"Ö"];
    s = [s stringByReplacingOccurrencesOfString:@"&#215;"
                                     withString:@"×"];
    s = [s stringByReplacingOccurrencesOfString:@"&times;"
                                     withString:@"×"];
    s = [s stringByReplacingOccurrencesOfString:@"&#216;"
                                     withString:@"Ø"];
    s = [s stringByReplacingOccurrencesOfString:@"&Oslash;"
                                     withString:@"Ø"];
    s = [s stringByReplacingOccurrencesOfString:@"&#217;"
                                     withString:@"Ù"];
    s = [s stringByReplacingOccurrencesOfString:@"&Ugrave;"
                                     withString:@"Ù"];
    s = [s stringByReplacingOccurrencesOfString:@"&#218;"
                                     withString:@"Ú"];
    s = [s stringByReplacingOccurrencesOfString:@"&Uacute;"
                                     withString:@"Ú"];
    s = [s stringByReplacingOccurrencesOfString:@"&#219;"
                                     withString:@"Û"];
    s = [s stringByReplacingOccurrencesOfString:@"&Ucirc;"
                                     withString:@"Û"];
    s = [s stringByReplacingOccurrencesOfString:@"&#220;"
                                     withString:@"Ü"];
    s = [s stringByReplacingOccurrencesOfString:@"&Uuml;"
                                     withString:@"Ü"];
    s = [s stringByReplacingOccurrencesOfString:@"&#221;"
                                     withString:@"Ý"];
    s = [s stringByReplacingOccurrencesOfString:@"&Yacute;"
                                     withString:@"Ý"];
    s = [s stringByReplacingOccurrencesOfString:@"&#222;"
                                     withString:@"Þ"];
    s = [s stringByReplacingOccurrencesOfString:@"&THORN;"
                                     withString:@"Þ"];
    s = [s stringByReplacingOccurrencesOfString:@"&#223;"
                                     withString:@"ß"];
    s = [s stringByReplacingOccurrencesOfString:@"&szlig;"
                                     withString:@"ß"];
    s = [s stringByReplacingOccurrencesOfString:@"&#224;"
                                     withString:@"à"];
    s = [s stringByReplacingOccurrencesOfString:@"&agrave;"
                                     withString:@"à"];
    s = [s stringByReplacingOccurrencesOfString:@"&#225;"
                                     withString:@"á"];
    s = [s stringByReplacingOccurrencesOfString:@"&aacute;"
                                     withString:@"á"];
    s = [s stringByReplacingOccurrencesOfString:@"&#226;"
                                     withString:@"â"];
    s = [s stringByReplacingOccurrencesOfString:@"&acirc;"
                                     withString:@"â"];
    s = [s stringByReplacingOccurrencesOfString:@"&#227;"
                                     withString:@"ã"];
    s = [s stringByReplacingOccurrencesOfString:@"&atilde;"
                                     withString:@"ã"];
    s = [s stringByReplacingOccurrencesOfString:@"&#228;"
                                     withString:@"ä"];
    s = [s stringByReplacingOccurrencesOfString:@"&auml;"
                                     withString:@"ä"];
    s = [s stringByReplacingOccurrencesOfString:@"&#229;"
                                     withString:@"å"];
    s = [s stringByReplacingOccurrencesOfString:@"&aring;"
                                     withString:@"å"];
    s = [s stringByReplacingOccurrencesOfString:@"&#230;"
                                     withString:@"æ"];
    s = [s stringByReplacingOccurrencesOfString:@"&aelig;"
                                     withString:@"æ"];
    s = [s stringByReplacingOccurrencesOfString:@"&#231;"
                                     withString:@"ç"];
    s = [s stringByReplacingOccurrencesOfString:@"&ccedil;"
                                     withString:@"ç"];
    s = [s stringByReplacingOccurrencesOfString:@"&#232;"
                                     withString:@"è"];
    s = [s stringByReplacingOccurrencesOfString:@"&egrave;"
                                     withString:@"è"];
    s = [s stringByReplacingOccurrencesOfString:@"&#233;"
                                     withString:@"é"];
    s = [s stringByReplacingOccurrencesOfString:@"&eacute;"
                                     withString:@"é"];
    s = [s stringByReplacingOccurrencesOfString:@"&#234;"
                                     withString:@"ê"];
    s = [s stringByReplacingOccurrencesOfString:@"&ecirc;"
                                     withString:@"ê"];
    s = [s stringByReplacingOccurrencesOfString:@"&#235;"
                                     withString:@"ë"];
    s = [s stringByReplacingOccurrencesOfString:@"&euml;"
                                     withString:@"ë"];
    s = [s stringByReplacingOccurrencesOfString:@"&#236;"
                                     withString:@"ì"];
    s = [s stringByReplacingOccurrencesOfString:@"&igrave;"
                                     withString:@"ì"];
    s = [s stringByReplacingOccurrencesOfString:@"&#237;"
                                     withString:@"í"];
    s = [s stringByReplacingOccurrencesOfString:@"&iacute;"
                                     withString:@"í"];
    s = [s stringByReplacingOccurrencesOfString:@"&#238;"
                                     withString:@"î"];
    s = [s stringByReplacingOccurrencesOfString:@"&icirc;"
                                     withString:@"î"];
    s = [s stringByReplacingOccurrencesOfString:@"&#239;"
                                     withString:@"ï"];
    s = [s stringByReplacingOccurrencesOfString:@"&iuml;"
                                     withString:@"ï"];
    s = [s stringByReplacingOccurrencesOfString:@"&#240;"
                                     withString:@"ð"];
    s = [s stringByReplacingOccurrencesOfString:@"&eth;"
                                     withString:@"ð"];
    s = [s stringByReplacingOccurrencesOfString:@"&#241;"
                                     withString:@"ñ"];
    s = [s stringByReplacingOccurrencesOfString:@"&ntilde;"
                                     withString:@"ñ"];
    s = [s stringByReplacingOccurrencesOfString:@"&#242;"
                                     withString:@"ò"];
    s = [s stringByReplacingOccurrencesOfString:@"&ograve;"
                                     withString:@"ò"];
    s = [s stringByReplacingOccurrencesOfString:@"&#243;"
                                     withString:@"ó"];
    s = [s stringByReplacingOccurrencesOfString:@"&oacute;"
                                     withString:@"ó"];
    s = [s stringByReplacingOccurrencesOfString:@"&#244;"
                                     withString:@"ô"];
    s = [s stringByReplacingOccurrencesOfString:@"&ocirc;"
                                     withString:@"ô"];
    s = [s stringByReplacingOccurrencesOfString:@"&#245;"
                                     withString:@"õ"];
    s = [s stringByReplacingOccurrencesOfString:@"&otilde;"
                                     withString:@"õ"];
    s = [s stringByReplacingOccurrencesOfString:@"&#246;"
                                     withString:@"ö"];
    s = [s stringByReplacingOccurrencesOfString:@"&ouml;"
                                     withString:@"ö"];
    s = [s stringByReplacingOccurrencesOfString:@"&#247;"
                                     withString:@"÷"];
    s = [s stringByReplacingOccurrencesOfString:@"&divide;"
                                     withString:@"÷"];
    s = [s stringByReplacingOccurrencesOfString:@"&#248;"
                                     withString:@"ø"];
    s = [s stringByReplacingOccurrencesOfString:@"&oslash;"
                                     withString:@"ø"];
    s = [s stringByReplacingOccurrencesOfString:@"&#249;"
                                     withString:@"ù"];
    s = [s stringByReplacingOccurrencesOfString:@"&ugrave;"
                                     withString:@"ù"];
    s = [s stringByReplacingOccurrencesOfString:@"&#250;"
                                     withString:@"ú"];
    s = [s stringByReplacingOccurrencesOfString:@"&uacute;"
                                     withString:@"ú"];
    s = [s stringByReplacingOccurrencesOfString:@"&#251;"
                                     withString:@"û"];
    s = [s stringByReplacingOccurrencesOfString:@"&ucirc;"
                                     withString:@"û"];
    s = [s stringByReplacingOccurrencesOfString:@"&#252;"
                                     withString:@"ü"];
    s = [s stringByReplacingOccurrencesOfString:@"&uuml;"
                                     withString:@"ü"];
    s = [s stringByReplacingOccurrencesOfString:@"&#253;"
                                     withString:@"ý"];
    s = [s stringByReplacingOccurrencesOfString:@"&yacute;"
                                     withString:@"ý"];
    s = [s stringByReplacingOccurrencesOfString:@"&#254;"
                                     withString:@"þ"];
    s = [s stringByReplacingOccurrencesOfString:@"&thorn;"
                                     withString:@"þ"];
    s = [s stringByReplacingOccurrencesOfString:@"&#255;"
                                     withString:@"ÿ"];
    s = [s stringByReplacingOccurrencesOfString:@"&yuml;"
                                     withString:@"ÿ"];
    s = [s stringByReplacingOccurrencesOfString:@"&Alpha;"
                                     withString:@"Α"];
    s = [s stringByReplacingOccurrencesOfString:@"&alpha;"
                                     withString:@"α"];
    s = [s stringByReplacingOccurrencesOfString:@"&Beta;"
                                     withString:@"Β"];
    s = [s stringByReplacingOccurrencesOfString:@"&beta;"
                                     withString:@"β"];
    s = [s stringByReplacingOccurrencesOfString:@"&Gamma;"
                                     withString:@"Γ"];
    s = [s stringByReplacingOccurrencesOfString:@"&gamma;"
                                     withString:@"γ"];
    s = [s stringByReplacingOccurrencesOfString:@"&Delta;"
                                     withString:@"Δ"];
    s = [s stringByReplacingOccurrencesOfString:@"&delta;"
                                     withString:@"δ"];
    s = [s stringByReplacingOccurrencesOfString:@"&Epsilon;"
                                     withString:@"Ε"];
    s = [s stringByReplacingOccurrencesOfString:@"&epsilon;"
                                     withString:@"ε"];
    s = [s stringByReplacingOccurrencesOfString:@"&Zeta;"
                                     withString:@"Ζ"];
    s = [s stringByReplacingOccurrencesOfString:@"&zeta;"
                                     withString:@"ζ"];
    s = [s stringByReplacingOccurrencesOfString:@"&Eta;"
                                     withString:@"Η"];
    s = [s stringByReplacingOccurrencesOfString:@"&eta;"
                                     withString:@"η"];
    s = [s stringByReplacingOccurrencesOfString:@"&Theta;"
                                     withString:@"Θ"];
    s = [s stringByReplacingOccurrencesOfString:@"&theta;"
                                     withString:@"θ"];
    s = [s stringByReplacingOccurrencesOfString:@"&Iota;"
                                     withString:@"Ι"];
    s = [s stringByReplacingOccurrencesOfString:@"&iota;"
                                     withString:@"ι"];
    s = [s stringByReplacingOccurrencesOfString:@"&Kappa;"
                                     withString:@"Κ"];
    s = [s stringByReplacingOccurrencesOfString:@"&kappa;"
                                     withString:@"κ"];
    s = [s stringByReplacingOccurrencesOfString:@"&Lambda;"
                                     withString:@"Λ"];
    s = [s stringByReplacingOccurrencesOfString:@"&lambda;"
                                     withString:@"λ"];
    s = [s stringByReplacingOccurrencesOfString:@"&Mu;"
                                     withString:@"Μ"];
    s = [s stringByReplacingOccurrencesOfString:@"&mu;"
                                     withString:@"μ"];
    s = [s stringByReplacingOccurrencesOfString:@"&Nu;"
                                     withString:@"Ν"];
    s = [s stringByReplacingOccurrencesOfString:@"&nu;"
                                     withString:@"ν"];
    s = [s stringByReplacingOccurrencesOfString:@"&Xi;"
                                     withString:@"Ξ"];
    s = [s stringByReplacingOccurrencesOfString:@"&xi;"
                                     withString:@"ξ"];
    s = [s stringByReplacingOccurrencesOfString:@"&Omicron;"
                                     withString:@"Ο"];
    s = [s stringByReplacingOccurrencesOfString:@"&omicron;"
                                     withString:@"ο"];
    s = [s stringByReplacingOccurrencesOfString:@"&Pi;"
                                     withString:@"Π"];
    s = [s stringByReplacingOccurrencesOfString:@"&pi;"
                                     withString:@"π"];
    s = [s stringByReplacingOccurrencesOfString:@"&Rho;"
                                     withString:@"Ρ"];
    s = [s stringByReplacingOccurrencesOfString:@"&rho;"
                                     withString:@"ρ"];
    s = [s stringByReplacingOccurrencesOfString:@"&Sigma;"
                                     withString:@"Σ"];
    s = [s stringByReplacingOccurrencesOfString:@"&sigma;"
                                     withString:@"σ"];
    s = [s stringByReplacingOccurrencesOfString:@"&Tau;"
                                     withString:@"Τ"];
    s = [s stringByReplacingOccurrencesOfString:@"&tau;"
                                     withString:@"τ"];
    s = [s stringByReplacingOccurrencesOfString:@"&Upsilon;"
                                     withString:@"Υ"];
    s = [s stringByReplacingOccurrencesOfString:@"&upsilon;"
                                     withString:@"υ"];
    s = [s stringByReplacingOccurrencesOfString:@"&Phi;"
                                     withString:@"Φ"];
    s = [s stringByReplacingOccurrencesOfString:@"&phi;"
                                     withString:@"φ"];
    s = [s stringByReplacingOccurrencesOfString:@"&Chi;"
                                     withString:@"Χ"];
    s = [s stringByReplacingOccurrencesOfString:@"&chi;"
                                     withString:@"χ"];
    s = [s stringByReplacingOccurrencesOfString:@"&Psi;"
                                     withString:@"Ψ"];
    s = [s stringByReplacingOccurrencesOfString:@"&psi;"
                                     withString:@"ψ"];
    s = [s stringByReplacingOccurrencesOfString:@"&Omega;"
                                     withString:@"Ω"];
    s = [s stringByReplacingOccurrencesOfString:@"&omega;"
                                     withString:@"ω"];
    s = [s stringByReplacingOccurrencesOfString:@"&#9679;"
                                     withString:@"●"];
    s = [s stringByReplacingOccurrencesOfString:@"&#8226;"
                                     withString:@"•"];
    NSMutableString *sMutable = [NSMutableString stringWithString:s];
    return sMutable;
}


- (void)parserDidEndDocument:(NSXMLParser *)parser {
//    NSLog(@"all done!");
//    NSLog(@"array has %d items", [_newsItems count]);
    done = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



@end

