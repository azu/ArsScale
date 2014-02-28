//
// Created by azu on 2014/01/04.
//


#import "ArsScaleLinear.h"
#import "ArsBisector.h"
#import "ArsScaleNice.h"
#import "ArsTickRange.h"
#import "ArsDashFunction.h"


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

typedef ArsIdentityNumber (^ArsLinear)(NSArray *domain, NSArray *range, ArsUninterpolate unInterpolate, ArsInterpolate interpolate);

#pragma mark - static function

static ArsLinear const scale_polylinear = ^ArsIdentityNumber(NSArray *domain, NSArray *range, ArsUninterpolate unInterpolate, ArsInterpolate interpolate) {
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
        ArsIdentityNumber uFn = doneDomain[insertIndex];
        ArsIdentityNumber iFn = doneRange[insertIndex];
        return iFn(uFn(number));
    };
};

static ArsLinear const scale_bilinear = ^(NSArray *domain, NSArray *range, ArsUninterpolate uninterpolate, ArsInterpolate interpolate) {
    ArsIdentityNumber uFn = uninterpolate(domain[0], domain[1]);
    ArsIdentityNumber iFn = interpolate(range[0], range[1]);
    return ^NSNumber *(NSNumber *number) {
        return iFn(uFn(number));
    };
};

static ArsInterpolate const interpolateNumber = ^ArsIdentityNumber(NSNumber *a, NSNumber *b) {
    double aValue = [a doubleValue];
    double bValue = [b doubleValue];
    double diffValue = bValue - aValue;
    return ^NSNumber *(NSNumber *number) {
        double resultValue = aValue + diffValue * [number doubleValue];
        return @(resultValue);
    };
};

static ArsUninterpolate const uninterpolateNumber = ^ArsIdentityNumber(NSNumber *a, NSNumber *b) {
    double aValue = [a doubleValue];
    double bValue = [b doubleValue];
    double diffValue = bValue - aValue;
    double reBee = diffValue != 0 ? 1 / diffValue : 0;
    return ^NSNumber *(NSNumber *number) {
        return @(([number doubleValue] - aValue) * reBee);
    };
};

static ArsUninterpolate const uninterpolateClamp = ^ArsIdentityNumber(NSNumber *a, NSNumber *b) {
    double aValue = [a doubleValue];
    double bValue = [b doubleValue];
    double diffValue = bValue - aValue;
    double reBee = diffValue != 0 ? 1 / diffValue : 0;
    return ^NSNumber *(NSNumber *number) {
        double resultValue = ([number doubleValue] - aValue) * reBee;
        return @(MAX(0, MIN(1, resultValue)));
    };
};


- (void (^)(void))nice {
    return ^{
        self.niceByStep(10);
    };
}

- (void (^)(NSUInteger))niceByStep {
    __weak typeof (self) that = self;
    return ^void(NSUInteger step) {
        ArsTickRange *tickRange = [that tickRangeForLinear:that.domain count:step];
        NSArray *niceDomain;
        if (tickRange.step) {
            niceDomain = ars_scale_nice(that.domain, tickRange.step);
        } else {
            niceDomain = ars_scale_nice(that.domain);
        }
        that.domain = niceDomain;
    };
}

- (ArsInterpolate)interpolate {
    if (_interpolate) {
        return _interpolate;
    }
    return interpolateNumber;
}

- (ArsUninterpolate)uninterpolate {
    if (_uninterpolate) {
        return _uninterpolate;
    }
    if (self.clamp) {
        return uninterpolateClamp;
    } else {
        return uninterpolateNumber;
    }
}
#pragma mark - linear
- (NSArray *)scaleExtend:(NSArray *) domain {
    NSNumber *start = [domain firstObject];
    NSNumber *stop = [domain lastObject];
    return [start doubleValue] < [stop doubleValue] ? @[start, stop] : @[stop, start];
}

- (ArsTickRange *)tickRangeForLinear:(NSArray *) domain count:(NSUInteger) stepCount {
    NSArray *extentDomain = [self scaleExtend:domain];
    double firstValue = [[extentDomain firstObject] doubleValue];
    double lastValue = [[extentDomain lastObject] doubleValue];
    // step is nan...
    double span = lastValue - firstValue;
    if (span == 0) {
        return [ArsTickRange rangeWithStart:[extentDomain firstObject] stop:[extentDomain lastObject]];
    }
    double step = pow(10, floor(log10(span / stepCount)));
    double err = stepCount / span * step;
    // Filter ticks to get closer to the desired count.
    if (err <= .15) step *= 10;
    else if (err <= .35) step *= 5;
    else if (err <= .75) step *= 2;

    ArsTickRange *arsTickRange = [[ArsTickRange alloc] init];
    // Round start and stop values to step interval.
    arsTickRange.start = @(ceil(firstValue / step) * step);
    arsTickRange.stop = @(floor(lastValue / step) * step + step * .5); // inclusive
    arsTickRange.step = @(step);
    return arsTickRange;
}

- (ArsLinear)linear {
    NSUInteger count = MIN(self.domain.count, self.range.count);
    NSAssert(count > 0, @"must Set domain/range");
    if (count > 2) {
        return scale_polylinear;
    } else {
        // [0,1]
        return scale_bilinear;
    }
}

- (ArsIdentityNumber)p_scaler {
    ArsLinear linear = [self linear];
    ArsUninterpolate uninterpolate = [self uninterpolate];
    ArsInterpolate interpolate = [self interpolate];
    return linear(self.domain, self.range, uninterpolate, interpolate);
}

- (ArsIdentityNumber)p_inverter {
    ArsLinear linear = [self linear];
    ArsUninterpolate uninterpolate = [self uninterpolate];
    // inverse : range <-> domain
    return linear(self.range, self.domain, uninterpolate, interpolateNumber);
}

- (NSNumber *)scale:(NSNumber *) number {
    return [self p_scaler](number);
}


- (NSNumber *)invert:(NSNumber *) number {
    return [self p_inverter](number);
}

- (NSArray *)ticks:(NSUInteger) count {
    ArsTickRange *tickRange = [self tickRangeForLinear:self.domain count:count];
    NSArray *array = ArsRange(tickRange.start, tickRange.stop, tickRange.step);
    return ArsRoundInteger(array);
}


@end