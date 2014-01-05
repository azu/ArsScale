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

static ArsLinear const scale_polylinear = ^ArsIdentifierNumber(NSArray *domain, NSArray *range, ArsUninterpolate unInterpolate, ArsInterpolate interpolate) {
    NSUInteger minLastIndex = MIN(domain.count, range.count) - 1;
    NSArray *sortedDomain = domain;
    NSArray *sortedRange = range;
    // last < first
    if ([domain.lastObject compare:domain.firstObject] == NSOrderedAscending) {
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

static ArsLinear const scale_bilinear = ^(NSArray *domain, NSArray *range, ArsUninterpolate uninterpolate, ArsInterpolate interpolate) {
    ArsIdentifierNumber uFn = uninterpolate(domain[0], domain[1]);
    ArsIdentifierNumber iFn = interpolate(range[0], range[1]);
    return ^NSNumber *(NSNumber *number) {
        return iFn(uFn(number));
    };
};

- (ArsLinear)linear {
    NSUInteger count = MIN(self.domain.count, self.range.count);
    NSAssert(count > 0, @"must set domain/range");
    if (count > 2) {
        return scale_polylinear;
    } else {
        return scale_bilinear;
    }
}

#pragma mark - static function
static ArsInterpolate const interpolateNumber = ^ArsIdentifierNumber(NSNumber *a, NSNumber *b) {
    float aValue = [a floatValue];
    float bValue = [b floatValue];
    float diffValue = bValue - aValue;
    return ^NSNumber *(NSNumber *number) {
        float resultValue = aValue + diffValue * [number floatValue];
        return @(resultValue);
    };
};

static ArsUninterpolate const uninterpolateNumber = ^ArsIdentifierNumber(NSNumber *a, NSNumber *b) {
    float aValue = [a floatValue];
    float bValue = [b floatValue];
    float diffValue = bValue - aValue;
    float resultValue = diffValue != 0 ? 1 / diffValue : 0;
    return ^NSNumber *(NSNumber *number) {
        return @(([number floatValue] - aValue) * resultValue);
    };
};

static ArsUninterpolate const uninterpolateClamp = ^ArsIdentifierNumber(NSNumber *a, NSNumber *b) {
    float aValue = [a floatValue];
    float bValue = [b floatValue];
    float diffValue = bValue - aValue;
    return ^NSNumber *(NSNumber *number) {
        float resultValue = aValue + diffValue * [number floatValue];
        return @(MAX(0, MIN(1, resultValue)));
    };
};

- (ArsInterpolate)interpolate {
    return interpolateNumber;
}

- (ArsUninterpolate)uninterpolate {
    if (self.clamp) {
        return uninterpolateClamp;
    } else {
        return uninterpolateNumber;
    }
}

- (ArsIdentifierNumber)p_output {
    ArsLinear linear = [self linear];
    ArsUninterpolate uninterpolate = [self uninterpolate];
    ArsInterpolate interpolate = [self interpolate];
    return linear(self.domain, self.range, uninterpolate, interpolate);
}

- (ArsIdentifierNumber)p_input {
    ArsLinear linear = [self linear];
    ArsUninterpolate uninterpolate = [self uninterpolate];
    // inverse : range <-> domain
    return linear(self.range, self.domain, uninterpolate, interpolateNumber);
}

- (NSNumber *)scale:(NSNumber *) number {
    return [self p_output](number);
}


- (NSNumber *)invert:(NSNumber *) number {
    return [self p_input](number);
}


@end