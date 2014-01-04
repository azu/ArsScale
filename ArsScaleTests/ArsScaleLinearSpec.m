//
// Created by azu on 2014/01/04.
//


#import "Kiwi.h"
#import "ArsScaleLinear.h"

SPEC_BEGIN(ArsScaleLinearSpec)
    __block ArsScaleLinear *linear;
    beforeEach(^{
        linear = [[ArsScaleLinear alloc] init];
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
        double delta = 1e-6;
        context(@"when default", ^{
            it(@"should return within [0,1]", ^{
                [[[linear scale:@.5] should] equal:.5 withDelta:delta];
            });
        });
        context(@"when domain [1,2]", ^{
            beforeEach(^{
                linear.domain = @[@1, @2];
            });
            it(@"should return map number", ^{
                [[[linear scale:@.5] should] equal:-.5 withDelta:delta];
                [[[linear scale:@1] should] equal:0 withDelta:delta];
                [[[linear scale:@1.5] should] equal:.5 withDelta:delta];
                [[[linear scale:@2] should] equal:1 withDelta:delta];
                [[[linear scale:@2.5] should] equal:1.5 withDelta:delta];
            });
        });
        context(@"when domain [4,2,1]", ^{
            beforeEach(^{
                linear.domain = @[@4, @2, @1];
                linear.range = @[@1, @2, @4];
            });
            it(@"can convert a polylinear descending domsin", ^{
                [[[linear scale:@(1)] should] equal:4 withDelta:delta];
                [[[linear scale:@(3)] should] equal:1.5 withDelta:delta];
            });
        });
    });
    SPEC_END