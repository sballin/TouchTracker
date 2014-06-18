//
//  DictionaryBuilder.m
//  TouchTracker
//
//  Created by Sean on 6/10/14.
//  Copyright (c) 2014 Sean. All rights reserved.
//

#import "DictionaryBuilder.h"
#import "Snake.h"

@interface DictionaryBuilder ()
@property (nonatomic, strong) NSArray *dictionaryWords;
@property (nonatomic, strong) Snake *snake;
@end

@implementation DictionaryBuilder

@synthesize dictionaryWords = _dictionaryWords;
@synthesize snake = _snake;
@synthesize snakeDictionary = _snakeDictionary;

- (Snake *) snake {
    if (!_snake) _snake = [[Snake alloc] init];
    return _snake;
}

- (NSMutableDictionary *)snakeDictionary {
    if (!_snakeDictionary) _snakeDictionary = [[NSMutableDictionary alloc] init];
    return _snakeDictionary;
}

- (NSArray *)dictionaryWords {
	if (!_dictionaryWords) {
		_dictionaryWords = [[NSMutableArray alloc] init];
		NSString *path = [[NSBundle mainBundle] pathForResource:@"dict" ofType:@"txt"];
		NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
		_dictionaryWords = [content componentsSeparatedByString:@"\r"];
	}

	return _dictionaryWords;
}

- (void)writeSnakeDictionary:(int)spread {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *dictPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"snakeDictionary.plist"];
	_snakeDictionary = [NSMutableDictionary dictionaryWithCapacity:[self.dictionaryWords count]];
	for (NSString *word in self.dictionaryWords) {
		if ([word length] >= 3) {
			NSString *path = [self.snake snakePathOfWord:word withSpread:spread];
			NSMutableArray *list = [_snakeDictionary objectForKey:path];
			if (list == nil) list = [[NSMutableArray alloc] init];
			[list addObject:word];
			[_snakeDictionary setObject:list forKey:path];
		}
	}
	//[NSKeyedArchiver archiveRootObject:_snakeDictionary toFile:@"snakeDictionary.plist"];
	[self.snakeDictionary writeToFile:dictPath atomically:YES];
}

@end
