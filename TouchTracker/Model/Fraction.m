//
//  Fraction.m
//  TouchTracker
//
//  Created by Sean on 7/10/14.
//  Copyright (c) 2014 Sean. All rights reserved.
//

#import "Fraction.h"
#import "KeyMath.h"

@interface Fraction ()
@property (nonatomic, strong) KeyMath *keyboard;
- (NSArray *)horizontalFractionPath:(NSArray *)touchSequence;
- (NSArray *)verticalFractionPath:(NSArray *)touchSequence;
- (NSArray *)horizontalFractionGraph:(NSArray *)touchSequence;
- (NSArray *)verticalFractionGraph:(NSArray *)touchSequence;
@end

@implementation Fraction

@synthesize keyboard = _keyboard;

- (KeyMath *)keyboard {
    if (!_keyboard) _keyboard = [[KeyMath alloc] init];
    return _keyboard;
}

- (NSArray *)horizontalFractionPath:(NSArray *)touchSequence {
	float total = 0.0;
    NSMutableArray *path = [NSMutableArray arrayWithCapacity:touchSequence.count - 1];
	for (int i = 0; i < touchSequence.count - 1; i++) {
        CGPoint firstPoint, secondPoint;
        [touchSequence[i] getValue:&firstPoint];
        [touchSequence[i+1] getValue:&secondPoint];
        float distance = fabs(firstPoint.x - firstPoint.y);
        path[i] = @(distance);
        total += distance;
	}
	for (int i = 0; i < [path count]; i++) {
		float fraction = [path[i] floatValue] / total;
		path[i] = @(fraction);
	}
	return [path copy];
}

- (NSArray *)verticalFractionPath:(NSArray *)touchSequence {
    float total = 0.0;
    NSMutableArray *path = [NSMutableArray arrayWithCapacity:touchSequence.count - 1];
    for (int i = 0; i < touchSequence.count - 1; i++) {
        CGPoint firstPoint, secondPoint;
        [touchSequence[i] getValue:&firstPoint];
        [touchSequence[i+1] getValue:&secondPoint];
        float distance = fabs(firstPoint.x - firstPoint.y);
        path[i] = @(distance);
        total += distance;
    }
    for (int i = 0; i < [path count]; i++) {
        float fraction = [path[i] floatValue] / total;
        path[i] = @(fraction);
    }
    return [path copy];
}

- (NSArray *)horizontalFractionGraph:(NSArray *)touchSequence {
    float total = 0.0;
    NSMutableArray *path = [[NSMutableArray alloc] init];
    for (int i = 1; i < touchSequence.count; i++) {
        for (int j = 0; j < i; j++) {
            CGPoint firstPoint, secondPoint;
            [touchSequence[i] getValue:&firstPoint];
            [touchSequence[j] getValue:&secondPoint];
            float distance = fabs(firstPoint.x - secondPoint.x);
            [path addObject:@(distance)];
            total += distance;
        }
    }
    for (int i = 0; i < [path count]; i++) {
        float fraction = [path[i] floatValue] / total;
        path[i] = @(fraction*1000);
    }
    return [path copy];
}

- (NSArray *)verticalFractionGraph:(NSArray *)touchSequence {
    float total = 0.0;
    NSMutableArray *path = [[NSMutableArray alloc] init];
    for (int i = 1; i < touchSequence.count; i++) {
        for (int j = 0; j < i; j++) {
            CGPoint firstPoint, secondPoint;
            [touchSequence[i] getValue:&firstPoint];
            [touchSequence[j] getValue:&secondPoint];
            float distance = fabs(firstPoint.y - secondPoint.y);
            [path addObject:@(distance)];
            total += distance;
        }
    }
    for (int i = 0; i < [path count]; i++) {
        float fraction = [path[i] floatValue] / total;
        path[i] = @(fraction*1000);
    }
    return [path copy];
}

/**
 *  Total error between word and touchSequence as the sum, in
 *  quadrature, of differences between horizontal and vertical paths.
 */
- (float)twoDimPathErrorFor:(NSString *)word
                    against:(NSArray *)touchSequence {
    NSArray *horizontalPath = [self horizontalFractionPath:touchSequence];
    NSArray *verticalPath = [self verticalFractionPath:touchSequence];
    NSArray *horizontalWordPath = [self horizontalFractionPath:[self.keyboard modelTouchSequenceFor:word]];
    NSArray *verticalWordPath = [self verticalFractionPath:[self.keyboard modelTouchSequenceFor:word]];
    float horizontalError = 0.0;
    float verticalError = 0.0;
    // Add individual errors in quadrature.
    for (int i = 0; i < horizontalPath.count; i++) {
        horizontalError += powf([KeyMath errorBetween:[horizontalPath[i] floatValue] and:[horizontalWordPath[i] floatValue]], 2.0);
        verticalError += powf([KeyMath errorBetween:[verticalPath[i] floatValue] and:[verticalWordPath[i] floatValue]], 2.0);
    }
    // Add total errors in quadrature. Note errors are already squared.
    return sqrtf(horizontalError + verticalError);
}

/**
 *  TODO: actually compute graph (currently identical to path)
 */
- (float)twoDimGraphErrorFor:(NSString *)word
                     against:(NSArray *)touchSequence {
    NSArray *horizontalGraph = [self horizontalFractionGraph:touchSequence];
    NSArray *verticalGraph = [self verticalFractionGraph:touchSequence];
    NSArray *horizontalWordGraph = [self horizontalFractionGraph:[self.keyboard modelTouchSequenceFor:word]];
    NSArray *verticalWordGraph = [self verticalFractionGraph:[self.keyboard modelTouchSequenceFor:word]];
    float horizontalError = 0.0;
    float verticalError = 0.0;
    // Add individual errors in quadrature.
    for (int i = 0; i < horizontalGraph.count; i++) {
        horizontalError += powf([KeyMath errorBetween:[horizontalGraph[i] floatValue] and:[horizontalWordGraph[i] floatValue]], 2.0);
        verticalError += powf([KeyMath errorBetween:[verticalGraph[i] floatValue] and:[verticalWordGraph[i] floatValue]], 2.0);
    }
    // Add total errors in quadrature. Note errors are already squared.
    return sqrtf(horizontalError + verticalError);
}

/**
 *  Sort words by proximity of fraction paths in each direction to
 *  fraction path of touchSequence.
 *  TODO: Optimize sorting. Only need top few results, pure float sorting.
 */
- (NSMutableArray *)twoDimFractionSort:(NSArray *)words
                                 using:(NSArray *)touchSequence {
    NSMutableArray *bestMatches = words.mutableCopy;
	for (int i = 0; i < words.count; i++) {
		float error = [self twoDimPathErrorFor:words[i] against:touchSequence];
        bestMatches[i] = [NSString stringWithFormat:@"%.4f %@", error, words[i]];
	}
    [bestMatches sortUsingSelector:@selector(localizedCompare:)];
    return bestMatches;
}

/**
 *  Sort words by proximity to angle of vector between last two taps in
 *  touchSequence.
 */
- (NSMutableArray *)angleSort:(NSArray *)words
                        using:(NSArray *)touchSequence {
    float angle = [KeyMath lastAngleFor:touchSequence];
    NSMutableArray *bestMatches = words.mutableCopy;
    for (int i = 0; i < words.count; i++) {
        float error = fabs(angle - [self.keyboard lastAngleFor:words[i]]);
        bestMatches[i] = [NSString stringWithFormat:@"%.4f %@", error, words[i]];
    }
    [bestMatches sortUsingSelector:@selector(localizedCompare:)];
    return bestMatches;
}

@end
