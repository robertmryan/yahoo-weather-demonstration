//
//  XMLBlockParser.h
//
//  Created by Robert Ryan on 5/10/13.
//  Copyright (c) 2013 Robert Ryan. All rights reserved.
//

#import <Foundation/Foundation.h>

/// The `typedef` for the block to be called in `didStartElement`.

typedef void (^XMLParserBeginElementBlock)(NSArray *elementNames, NSDictionary *attributeDict);

/// The `typedef` for the block to be called in `didEndElement`, returning the characters received in `foundCharacters`.

typedef void (^XMLParserEndElementBlock)(NSArray *elementNames, NSString *value);

/// The `typedef` for the block to be called in `parseErrorOccurred`, returning the error received.

typedef void (^XMLParserErrorBlock)(NSError *error);

/** A block-based rendition of NSXMLParser
 
 This is a block-based implementation of the NSXMLParser. The notion here is to abstract the implementation details
 of a parser unique to your particular XML file out of the `NSXMLParserDelegate` calls so that you have a parser 
 that enjoys maximum reuse opportunities.
 
 The notion is that you 
 
 - create the `XMLBlockParser`; 
 - define either (or both) a `beginElementBlock` and an `endElementBlock`; and
 - initiate the parsing. 
 
 These two blocks return not just the element name, but rather an array of element names that
 represent the full nesting of the element tags. E.g., if you had an XML that looked like
 
    <items>
        <item>
            <name>Item #1</name>
            <url>http://some.random.url/item1/index.html</url>
        </item>
        <item>
            <name>Item #2</name>
            <url>http://some.random.url/item2/index.html</url>
        </item>
    </items>

 When parsing the `name` element, the elementNames parameters would be `@[@"items", @"item", @"name"]`
 (e.g. indicating that the `name` element name was encountered within an `item` element, which itself
 was found inside an `items` element). This can be useful for disambiguating when a particular element name
 can be used in different contexts with the XML (e.g. it's not unusual to see a `link` or `image` element name
 that is use if different contexts within the same XML feed).

 ## Usage
 
    XMLBlockParser *parser = [[XMLBlockParser alloc] initWithData:data];

    parser.beginElementBlock = ^(NSArray *elementNames, NSDictionary *attributeDict) {
        NSString *elementName = [elementNames lastObject];

        // Do here any parsing of the attributeDict values or other processing you want when you first encounter an element name
    };

    parser.endElementBlock = ^(NSArray *elementNames, NSString *value) {
        NSString *elementName = [elementNames lastObject];

        // Do here any parsing of the characters received between the starting element tag and the ending element tag
    };

    parser.errorBlock = ^(NSError *error) {
        NSLog(@"%s: error: %@", __FUNCTION__, error);
 
        // Do any addition error handling you want here
    };

    [parser parse];

 ## See also

 - [The XMLBlockParser project on github](http://www.github.com/robertmryan/xmlblockparser)

 @warning Note, do not set the `delegate` for this parser, as it is its own `NSXMLParserDelegate`.
 
 */

@interface XMLBlockParser : NSXMLParser

/// --------------------------------------------------------------
/// @name Properties
/// --------------------------------------------------------------

/** The block to be executed when the element begins
 
 This is used for the parsing of attributes that are encountered in `didStartElement`.
 */

@property (nonatomic, copy) XMLParserBeginElementBlock beginElementBlock;

/** The block to be executed when the element ends

 This is used for the parsing of the characters received by `foundCharacters`, namely
 those characters received after `didStartElement` but before `didEndElement`.
 */

@property (nonatomic, copy) XMLParserEndElementBlock endElementBlock;

/** The block to be executed if error occurs

 This is used to handle any parser errors returned.
 */

@property (nonatomic, copy) XMLParserErrorBlock errorBlock;

@end
