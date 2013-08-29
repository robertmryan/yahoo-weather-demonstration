//
//  XMLBlockParser.m
//
//  Created by Robert Ryan on 5/10/13.
//  Copyright (c) 2013 Robert Ryan. All rights reserved.
//

#import "XMLBlockParser.h"
#import "Model.h"

@interface XMLBlockParser () <NSXMLParserDelegate>

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSMutableArray *elementNames;
@property (nonatomic, strong) NSMutableString *value;

@property (nonatomic, weak) Model *model;

@end

@implementation XMLBlockParser

- (void)setDelegate:(id<NSXMLParserDelegate>)delegate
{
    NSLog(@"%s: You should not set delegate for this class", __FUNCTION__);
}

- (BOOL)parse
{
    [super setDelegate:self];
    return [super parse];
}

#pragma mark - NSXMLParserDelegate

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    self.elementNames = [[NSMutableArray alloc] init];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    [self.elementNames addObject:elementName];
    self.value = [[NSMutableString alloc] init];

    if (self.beginElementBlock)
        self.beginElementBlock(self.elementNames, attributeDict);
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [self.value appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if (self.endElementBlock)
        self.endElementBlock(self.elementNames, self.value);

    [self.elementNames removeLastObject];
    self.value = nil;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    self.elementNames = nil;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    if (self.errorBlock)
        self.errorBlock(parseError);
}

@end
