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

typedef NSNumber *(^IdentifierNumber)(NSNumber *number);

typedef IdentifierNumber(^Interpolate)(NSNumber *a, NSNumber *b);

typedef IdentifierNumber(^Uninterpolate)(NSNumber *a, NSNumber *b);

typedef IdentifierNumber (^Linear)(NSArray *domain, NSArray *range, Uninterpolate unInterpolate, Interpolate interpolate);

- (Linear)linear {
    return ^(NSArray *domain, NSArray *range, Uninterpolate uninterpolate, Interpolate interpolate) {
        IdentifierNumber u = uninterpolate(domain[0], domain[1]);
        IdentifierNumber i = interpolate(range[0], range[1]);
        return ^NSNumber *(NSNumber *number) {
            return i(u(number));
        };
    };
}

- (IdentifierNumber (^)(NSNumber *, NSNumber *))uninterpolate {
    IdentifierNumber (^uninterpolate)(NSNumber *, NSNumber *) = ^IdentifierNumber(NSNumber *a, NSNumber *b) {
        float aValue = [a floatValue];
        float bValue = [b floatValue];
        float result = bValue - aValue ? 1 / (bValue - aValue) : 0;
        return ^NSNumber *(NSNumber *number) {
            return @(([number floatValue] - aValue) * result);
        };
    };
    return uninterpolate;
}

- (IdentifierNumber (^)(NSNumber *, NSNumber *))interpolate {
    IdentifierNumber (^interpolate)(NSNumber *, NSNumber *) = ^IdentifierNumber(NSNumber *a, NSNumber *b) {
        return ^NSNumber *(NSNumber *number) {
            return number;
        };
    };
    return interpolate;
}

- (IdentifierNumber)p_output {
    Linear linear = [self linear];
    IdentifierNumber (^uninterpolate)(NSNumber *, NSNumber *) = [self uninterpolate];
    IdentifierNumber (^interpolate)(NSNumber *, NSNumber *) = [self interpolate];
    return linear(self.domain, self.range, uninterpolate, interpolate);
}

- (NSNumber *)scale:(NSNumber *) targetNumber {
    return [self p_output](targetNumber);
}


- (NSNumber *)invert:(NSNumber *) number {
    return nil;
}


@end