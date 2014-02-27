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

+ (instancetype)rangeWithStart:(NSNumber *) start stop:(NSNumber *) stop {
    return [[self alloc] initWithStart:start stop:stop];
}

@end