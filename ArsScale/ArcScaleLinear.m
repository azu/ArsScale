//
// Created by azu on 2014/01/04.
//


#import "ArcScaleLinear.h"

@implementation ArcScaleLinear {

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
    return ^(NSArray *domain, NSArray *range, ArsUninterpolate uninterpolate, ArsInterpolate interpolate) {
        ArsIdentifierNumber u = uninterpolate(domain[0], domain[1]);
        ArsIdentifierNumber i = interpolate(range[0], range[1]);
        return ^NSNumber *(NSNumber *number) {
            return i(u(number));
        };
    };
}

- (ArsUninterpolate)uninterpolate {
    ArsIdentifierNumber (^uninterpolate)(NSNumber *, NSNumber *) = ^ArsIdentifierNumber(NSNumber *a, NSNumber *b) {
        float aValue = [a floatValue];
        float bValue = [b floatValue];
        float result = bValue - aValue ? 1 / (bValue - aValue) : 0;
        return ^NSNumber *(NSNumber *number) {
            return @(([number floatValue] - aValue) * result);
        };
    };
    return uninterpolate;
}

- (ArsInterpolate)interpolate {
    ArsIdentifierNumber (^interpolate)(NSNumber *, NSNumber *) = ^ArsIdentifierNumber(NSNumber *a, NSNumber *b) {
        return ^NSNumber *(NSNumber *number) {
            return number;
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