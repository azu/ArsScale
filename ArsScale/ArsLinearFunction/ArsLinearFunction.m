//
// Created by azu on 2014/02/26.
//


#import "ArsLinearFunction.h"

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
