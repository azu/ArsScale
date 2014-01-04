//
// Created by azu on 2014/01/04.
//


#import "Kiwi.h"
#import "ArcScaleLinear.h"

SPEC_BEGIN(ArcScaleLinearSpec)
    __block ArcScaleLinear *linear;
    beforeEach(^{
        linear = [[ArcScaleLinear alloc] init];
    });
    afterEach(^{
        linear = nil;
    });
    describe(@"-domain", ^{
        context(@"when default", ^{
            it(@"should return [0,1]", ^{
                [[linear.domain should] equal:@[@0, @1]];
            });
        });
    });
    describe(@"-range", ^{
        context(@"when default", ^{
            it(@"should return [0,1]", ^{
                [[linear.range should] equal:@[@0, @1]];
            });
        });
    });

    describe(@"-scale", ^{
        context(@"when default", ^{
            it(@"should return within [0,1]", ^{
                [[[linear scale:@.5] should] equal:.5 withDelta:1e-6];
            });
        });
        context(@"when domain [1,2]", ^{
            beforeEach(^{
                linear.domain = @[@1, @2];
            });
            it(@"should return map number", ^{
                [[[linear scale:@.5] should] equal:-.5 withDelta:1e-6];
                [[[linear scale:@1] should] equal:0 withDelta:1e-6];
                [[[linear scale:@1.5] should] equal:.5 withDelta:1e-6];
                [[[linear scale:@2] should] equal:1 withDelta:1e-6];
                [[[linear scale:@2.5] should] equal:1.5 withDelta:1e-6];
            });
        });
    });
    SPEC_END