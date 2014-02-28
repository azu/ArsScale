//
// Created by azu on 2014/02/26.
//


#import <Foundation/Foundation.h>

// return min number - `ArsMin(@[@1,@2,@3]); => @1
__attribute__((overloadable)) NSNumber *ArsMin(NSArray *numbers);

// return max number - `ArsMaxb(@[@1,@2,@3]); => @3
__attribute__((overloadable)) NSNumber *ArsMax(NSArray *numbers);

#pragma mark - range
__attribute__((overloadable)) NSArray *ArsRange(NSNumber *start, NSNumber *stop);

__attribute__((overloadable)) NSArray *ArsRange(NSNumber *start, NSNumber *stop, NSNumber *step);

// round value of array
__attribute__((overloadable)) NSArray *ArsRoundInteger(NSArray *numbers);
