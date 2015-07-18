//
//  DictionaryBuilder.m
//  TouchTracker
//
//  Created by Sean on 6/10/14.
//  Copyright (c) 2014 Sean. All rights reserved.
//

#import "Dictionary.h"
#import "TwoDim.h"
#import "KeyMath.h"

@interface Dictionary ()
@property (nonatomic, strong) NSArray *dictionaryWords;
@property (nonatomic, strong) KeyMath *keyboard;
@end

@implementation Dictionary

@synthesize dictionaryWords = _dictionaryWords;
@synthesize keyboard = _keyboard;
@synthesize delegate;

- (KeyMath *)keyboard {
    if (!_keyboard) _keyboard = [[KeyMath alloc] init];
    return _keyboard;
}

- (NSMutableDictionary *)dictionaries {
    if (!_dictionaries) _dictionaries = [[NSMutableDictionary alloc] init];
    return _dictionaries;
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

- (void)sendProgressUpdate:(float)progress {
    if([delegate respondsToSelector:@selector(setProgress:)]) {
        [delegate performSelectorOnMainThread:@selector(setProgress:) withObject:[NSNumber numberWithFloat:progress] waitUntilDone:NO];
    }
}

- (void)writeDictionary:(NSString *)direction
          withTolerance:(NSNumber *)pixels {
    int i = 0; float wordCount = (float)[self.dictionaryWords count];
    SEL pathMaker = NSSelectorFromString([NSString stringWithFormat:@"%@PathFor:withTolerance:", direction]);
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:(int)wordCount];
    // Populate dictionary with paths as keys to lists of words with the same path
    for (NSString *word in self.dictionaryWords) {
        if ([word length] >= 2) {
            NSMutableArray *touchSequence = [self.keyboard modelTouchSequenceFor:word];
            NSString *path = [TwoDim performSelector:pathMaker withObject:touchSequence withObject:pixels];
            NSMutableArray *list = dictionary[path];
            if (!list) list = [[NSMutableArray alloc] init];
            [list addObject:word];
            dictionary[path] = list;
        }
        if (i++ % 1000 == 0) [self sendProgressUpdate:i/wordCount];
    }
    [self.dictionaries setValue:dictionary forKey:[NSString stringWithFormat:@"%@, tolerance %@px", direction, pixels]];
}

#define MAX_WORD_LENGTH 30
- (void)writeCountDictionary {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dictName = @"countDictionary.plist";
    NSString *dictPath = [paths[0] stringByAppendingPathComponent:dictName];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:[self.dictionaryWords count]];
    for (int i = 1; i < MAX_WORD_LENGTH; i++)
        dictionary[[NSString stringWithFormat:@"%d", i]] = [[NSMutableArray alloc] init];
    for (NSString *word in self.dictionaryWords) {
        NSString *length = [NSString stringWithFormat:@"%lu", (unsigned long)[word length]];
        NSMutableArray *list = dictionary[length];
        [list addObject:word];
        dictionary[length] = list;
    }
    [dictionary writeToFile:dictPath atomically:YES];
    [self.dictionaries setValue:dictionary forKey:@"word count"];
    NSLog(@"%@", dictPath);
}

@end