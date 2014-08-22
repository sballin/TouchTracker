//
//  DictionaryBuilder.m
//  TouchTracker
//
//  Created by Sean on 6/10/14.
//  Copyright (c) 2014 Sean. All rights reserved.
//

#import "DictionaryBuilder.h"
#import "Snake.h"
#import "Repeat.h"
#import "TwoDim.h"
#import "KeyMath.h"

@interface DictionaryBuilder ()
@property (nonatomic, strong) NSArray *dictionaryWords;
@property (nonatomic, strong) Snake *snake;
@property (nonatomic, strong) Repeat *repeat;
@property (nonatomic, strong) KeyMath *keyboard;
@end

@implementation DictionaryBuilder

@synthesize dictionaryWords = _dictionaryWords;
@synthesize snake = _snake;
@synthesize repeat = _repeat;
@synthesize keyboard = _keyboard;
@synthesize snakeDictionary = _snakeDictionary;
@synthesize countDictionary = _countDictionary;
@synthesize repeatDictionary = _repeatDictionary;
@synthesize horizontalDictionary = _horizontalDictionary;

- (Snake *)snake {
    if (!_snake) _snake = [[Snake alloc] init];
    return _snake;
}

- (Repeat *)repeat {
    if (!_repeat) _repeat = [[Repeat alloc] init];
    return _repeat;
}

- (KeyMath *)keyboard {
    if (!_keyboard) _keyboard = [[KeyMath alloc] init];
    return _keyboard;
}

- (NSMutableDictionary *)snakeDictionary {
    if (!_snakeDictionary) _snakeDictionary = [[NSMutableDictionary alloc] init];
    return _snakeDictionary;
}

- (NSMutableDictionary *)countDictionary{
    if (!_countDictionary) _countDictionary = [[NSMutableDictionary alloc] init];
    return _countDictionary;
}

- (NSMutableDictionary *)repeatDictionary {
    if (!_repeatDictionary) _repeatDictionary = [[NSMutableDictionary alloc] init];
    return _repeatDictionary;
}

- (NSMutableDictionary *)horizontalDictionary {
    if (!_horizontalDictionary) _horizontalDictionary = [[NSMutableDictionary alloc] init];
    return _horizontalDictionary;
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
    NSString *dictName = [[@"snakeDictionary" stringByAppendingString:[NSString stringWithFormat:@"%d", spread]] stringByAppendingString:@".plist"];
	NSString *dictPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:dictName];
    
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
	[self.snakeDictionary writeToFile:dictPath atomically:YES];
}

#define MAX_WORD_LENGTH 30
- (void)writeCountDictionary {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dictName = @"countDictionary.plist";
    NSString *dictPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:dictName];
    
    _countDictionary = [NSMutableDictionary dictionaryWithCapacity:[self.dictionaryWords count]];
    for (int i = 1; i < MAX_WORD_LENGTH; i++)
        [_countDictionary setObject:[[NSMutableArray alloc] init] forKey:[NSString stringWithFormat:@"%d", i]];
    for (NSString *word in self.dictionaryWords) {
        NSString *length = [NSString stringWithFormat:@"%lu", (unsigned long)[word length]];
        NSMutableArray *list = [_countDictionary objectForKey:length];
        [list addObject:word];
        [_countDictionary setObject:list forKey:length];
    }
    [self.countDictionary writeToFile:dictPath atomically:YES];
}

- (void)writeRepeatDictionary:(int)tolerance {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dictName = [[@"repeatDictionary" stringByAppendingString:[NSString stringWithFormat:@"%d", tolerance]] stringByAppendingString:@".plist"];
    NSString *dictPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:dictName];
    
    _repeatDictionary = [NSMutableDictionary dictionaryWithCapacity:[self.dictionaryWords count]];
    for (NSString *word in self.dictionaryWords) {
		if ([word length] >= 2) {
			NSString *path = [self.repeat repeatMapForWord:word withTolerance:tolerance];
			NSMutableArray *list = [_repeatDictionary objectForKey:path];
			if (list == nil) list = [[NSMutableArray alloc] init];
			[list addObject:word];
			[_repeatDictionary setObject:list forKey:path];
		}
	}
	[self.repeatDictionary writeToFile:dictPath atomically:YES];
}

- (void)writeHorizontalDictionary:(int)tolerance {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dictName = [[@"horizontalDictionary" stringByAppendingString:[NSString stringWithFormat:@"%d", tolerance]] stringByAppendingString:@".plist"];
    NSString *dictPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:dictName];
    
    _horizontalDictionary = [NSMutableDictionary dictionaryWithCapacity:[self.dictionaryWords count]];
    for (NSString *word in self.dictionaryWords) {
		if ([word length] >= 2) {
            NSMutableArray *touchSequence = [self.keyboard modelTouchSequenceFor:word];
            NSString *path = [TwoDim horizontalPathFor:touchSequence withTolerance:tolerance];
			NSMutableArray *list = [_horizontalDictionary objectForKey:path];
			if (!list) list = [[NSMutableArray alloc] init];
			[list addObject:word];
			[_horizontalDictionary setObject:list forKey:path];
		}
	}
	[self.horizontalDictionary writeToFile:dictPath atomically:YES];
    NSLog(@"%@", dictPath);
}

@end
