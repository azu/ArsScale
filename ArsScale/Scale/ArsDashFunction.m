//
// Created by azu on 2014/02/26.
//


#import "ArsDashFunction.h"

__attribute__((overloadable)) NSNumber *ArsMin(NSArray *numbers) {
    NSCParameterAssert(numbers != nil);
    return [numbers valueForKeyPath:@"@min.self"];
}

__attribute__((overloadable)) NSNumber *ArsMax(NSArray *numbers) {
    NSCParameterAssert(numbers != nil);
    return [numbers valueForKeyPath:@"@max.self"];
}


__attribute__((overloadable)) NSArray *ArsRange(NSNumber *start, NSNumber *stop) {
    return ArsRange(start, stop, @1);
}

__attribute__((overloadable)) NSArray *ArsRange(NSNumber *start, NSNumber *stop, NSNumber *step) {
    NSCParameterAssert(start != nil);
    NSCParameterAssert(stop != nil);
    NSCParameterAssert(![stop isEqualToNumber:@0]);
    NSCParameterAssert(step != nil);

    double startValue = [start doubleValue],
        stopValue = [stop doubleValue],
        stepValue = [step doubleValue];
    NSUInteger rangeLength = (NSUInteger)MAX(ceil((stopValue - startValue) / stepValue), 0);
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSUInteger i = 0; i < rangeLength; i++) {
        [mutableArray addObject:@(startValue)];
        startValue += stepValue;
    }

    return mutableArray;
}

__attribute__((overloadable)) NSArray *ArsRoundInteger(NSArray *numbers) {
    NSMutableArray *result = [NSMutableArray array];
    [numbers enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL *stop) {
        NSDecimal placeHolder;
        NSDecimal decimalValue = [obj decimalValue];
        NSDecimalRound(&placeHolder, &decimalValue, 3, NSRoundPlain);
        [result addObject:[NSDecimalNumber decimalNumberWithDecimal:placeHolder]];
    }];
    return result;
}
