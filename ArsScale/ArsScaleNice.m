//
// Created by azu on 2014/02/26.
//


#import "ArsScaleNice.h"
#import "ArsDashFunction.h"

__attribute__((overloadable)) NSArray *ars_scale_nice(NSArray *domain) {
    NSMutableArray *mutableArray = [domain mutableCopy];
    NSNumber *firstNumber = ArsMin(domain);
    NSNumber *lastNumber = ArsMax(domain);
    mutableArray[[domain indexOfObject:firstNumber]] = @(floor([firstNumber doubleValue]));
    mutableArray[[domain indexOfObject:lastNumber]] = @(ceil([lastNumber doubleValue]));
    return [mutableArray copy];
}

__attribute__((overloadable)) NSArray *ars_scale_nice(NSArray *domain, NSNumber *step) {
    NSMutableArray *mutableArray = [domain mutableCopy];
    NSNumber *firstNumber = ArsMin(domain);
    NSNumber *lastNumber = ArsMax(domain);
    double stepValue = [step doubleValue];
    NSUInteger firstValueIndex = [domain indexOfObject:firstNumber];
    NSUInteger lastValueIndex = [domain indexOfObject:lastNumber];
    mutableArray[firstValueIndex] = @(floor([firstNumber doubleValue] / stepValue) * stepValue);
    mutableArray[lastValueIndex] = @(ceil([lastNumber doubleValue] / stepValue) * stepValue);
    return [mutableArray copy];
}


