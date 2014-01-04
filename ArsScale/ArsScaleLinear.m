//
// Created by azu on 2014/01/04.
//


#import "ArsScaleLinear.h"
#import "ArsBisector.h"

@implementation ArsScaleLinear {

}
- (id)init {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    // default: input/output
    self.domain = @[@0, @1];
    self.range = @[@0, @1];

    return self;
}

typedef NSNumber *(^ArsIdentifierNumber)(NSNumber *number);

typedef ArsIdentifierNumber(^ArsInterpolate)(NSNumber *a, NSNumber *b);

typedef ArsIdentifierNumber(^ArsUninterpolate)(NSNumber *a, NSNumber *b);

typedef ArsIdentifierNumber (^ArsLinear)(NSArray *domain, NSArray *range, ArsUninterpolate unInterpolate, ArsInterpolate interpolate);

- (ArsLinear)linear {
    NSUInteger count = MIN(self.domain.count, self.range.count);
    NSAssert(count > 0, @"must set domain/range");
    if (count > 2) {
        ArsLinear pFunction = ^ArsIdentifierNumber(NSArray *domain, NSArray *range, ArsUninterpolate unInterpolate, ArsInterpolate interpolate) {
            NSUInteger minLastIndex = MIN(self.domain.count, self.range.count) - 1;
            NSArray *sortedDomain = domain;
            NSArray *sortedRange = range;
            if ([domain[minLastIndex] compare:domain[0]] == NSOrderedAscending) {
                sortedDomain = [[domain reverseObjectEnumerator] allObjects];
                sortedRange = [[range reverseObjectEnumerator] allObjects];
            }
            NSMutableArray *doneDomain = [NSMutableArray array];
            NSMutableArray *doneRange = [NSMutableArray array];
            NSUInteger i = 0;
            while (++i <= minLastIndex) {
                [doneDomain addObject:unInterpolate(sortedDomain[i - 1], sortedDomain[i])];
                [doneRange addObject:interpolate(sortedRange[i - 1], sortedRange[i])];
            }
            return ^NSNumber *(NSNumber *number) {
                NSUInteger insertIndex = [ArsBisector bisectRight:number inArray:sortedDomain low:1 hight:minLastIndex] - 1;
                ArsIdentifierNumber uFn = doneDomain[insertIndex];
                ArsIdentifierNumber iFn = doneRange[insertIndex];
                return iFn(uFn(number));
            };
        };
        return pFunction;
    } else {
        return ^(NSArray *domain, NSArray *range, ArsUninterpolate uninterpolate, ArsInterpolate interpolate) {
            ArsIdentifierNumber u = uninterpolate(domain[0], domain[1]);
            ArsIdentifierNumber i = interpolate(range[0], range[1]);
            return ^NSNumber *(NSNumber *number) {
                return i(u(number));
            };
        };
    }
}

- (ArsUninterpolate)uninterpolate {
    ArsIdentifierNumber (^uninterpolate)(NSNumber *, NSNumber *) = ^ArsIdentifierNumber(NSNumber *a, NSNumber *b) {
        float aValue = [a floatValue];
        float bValue = [b floatValue];
        float diffValue = bValue - aValue;
        float resultValue = diffValue != 0 ? 1 / diffValue : 0;
        return ^NSNumber *(NSNumber *number) {
            return @(([number floatValue] - aValue) * resultValue);
        };
    };
    return uninterpolate;
}

- (ArsInterpolate)interpolate {
    ArsIdentifierNumber (^interpolate)(NSNumber *, NSNumber *) = ^ArsIdentifierNumber(NSNumber *a, NSNumber *b) {
        float aValue = [a floatValue];
        float bValue = [b floatValue];
        float diffValue = bValue - aValue;
        return ^NSNumber *(NSNumber *number) {
            float resultValue = aValue + diffValue * [number floatValue];
            return @(resultValue);
        };
    };
    return interpolate;
}

- (ArsIdentifierNumber)p_output {
    ArsLinear linear = [self linear];
    ArsUninterpolate uninterpolate = [self uninterpolate];
    ArsInterpolate interpolate = [self interpolate];
    return linear(self.domain, self.range, uninterpolate, interpolate);
}

- (NSNumber *)scale:(NSNumber *) targetNumber {
    return [self p_output](targetNumber);
}


- (NSNumber *)invert:(NSNumber *) number {
    return nil;
}


@end