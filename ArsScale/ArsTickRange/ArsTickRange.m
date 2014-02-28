//
// Created by azu on 2014/02/26.
//


#import "ArsTickRange.h"


@implementation ArsTickRange {

}
- (instancetype)initWithStart:(NSNumber *) start stop:(NSNumber *) stop {
    self = [super init];
    if (self == nil) {
        return nil;
    }

    self.start = start;
    self.stop = stop;

    return self;
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass(
        [self class])];
    [description appendFormat:@"self.start=%@", self.start];
    [description appendFormat:@", self.stop=%@", self.stop];
    [description appendFormat:@", self.step=%@", self.step];
    [description appendString:@">"];
    return description;
}


+ (instancetype)rangeWithStart:(NSNumber *) start stop:(NSNumber *) stop {
    return [[self alloc] initWithStart:start stop:stop];
}

@end