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
    if (!_dictionaries) {
        // Load user dictionaries in Documents directory
        _dictionaries = [[NSMutableDictionary alloc] init];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSArray *contentPaths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:paths[0] error:nil];
        for (NSString *path in contentPaths) {
            if ([path hasSuffix:@".plist"] && [path containsString:@"Dict"] && ![path containsString:@"Dictionary"])
                _dictionaries[path.stringByDeletingPathExtension] = [NSDictionary dictionaryWithContentsOfFile:[paths[0] stringByAppendingPathComponent:path]];
        }
        // Load default dictionaries
        NSString *mainPath = [[NSBundle mainBundle] resourcePath];
        contentPaths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:mainPath error:nil];
        for (NSString *path in contentPaths) {
            if ([path hasSuffix:@".plist"] && [path containsString:@"Dict"] && ![path containsString:@"Dictionary"])
                _dictionaries[path.stringByDeletingPathExtension] = [NSDictionary dictionaryWithContentsOfFile:[mainPath stringByAppendingPathComponent:path]];
        }
    }
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
    if([delegate respondsToSelector:@selector(setProgress:)])
        [delegate performSelectorOnMainThread:@selector(setProgress:) withObject:[NSNumber numberWithFloat:progress] waitUntilDone:NO];
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
        if (++i % 3000 == 0) [self sendProgressUpdate:i/wordCount];
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dictName;
    if ([direction isEqualToString:@"repeat"])
        dictName = @"repeatDict.plist";
    else
        dictName = [NSString stringWithFormat:@"%@Dict%@.plist", direction, pixels];
    NSString *dictPath = [paths[0] stringByAppendingPathComponent:dictName];
    self.dictionaries[dictName.stringByDeletingPathExtension] = dictionary;
    [dictionary writeToFile:dictPath atomically:YES];
}

#define MAX_WORD_LENGTH 30
- (void)writeCountDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:[self.dictionaryWords count]];
    for (int i = 1; i < MAX_WORD_LENGTH; i++)
        dictionary[[NSString stringWithFormat:@"%d", i]] = [[NSMutableArray alloc] init];
    for (NSString *word in self.dictionaryWords) {
        NSString *length = [NSString stringWithFormat:@"%lu", (unsigned long)[word length]];
        NSMutableArray *list = dictionary[length];
        [list addObject:word];
        dictionary[length] = list;
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dictName = @"countDict.plist";
    NSString *dictPath = [paths[0] stringByAppendingPathComponent:dictName];
    [self.dictionaries setValue:dictionary forKey:@"countDict"];
    [dictionary writeToFile:dictPath atomically:YES];
}

@end
