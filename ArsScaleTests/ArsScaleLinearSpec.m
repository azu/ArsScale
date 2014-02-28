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

    double delta = 1e-6;
    describe(@"-scale", ^{
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
        context(@"when domain [4,2,1] range [1,2,4]", ^{
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
    describe(@"@propety clamp", ^{
        context(@"when default", ^{
            it(@"should return NO", ^{
                [[theValue(linear.clamp) should] beNo];
            });
        });
        context(@"when clamp is YES", ^{
            beforeEach(^{
                linear.clamp = YES;
            });
            it(@"can clamp to the domain", ^{
                [[[linear scale:@(-.5)] should] equal:0 withDelta:delta];
                [[[linear scale:@(.5)] should] equal:.5 withDelta:delta];
                [[[linear scale:@(1.5)] should] equal:1 withDelta:delta];
            });
            it(@"can clamp to the range", ^{
                linear.range = @[@1, @0];
                [[[linear invert:@(-.5)] should] equal:1 withDelta:delta];
                [[[linear invert:@(.5)] should] equal:.5 withDelta:delta];
                [[[linear invert:@(1.5)] should] equal:0 withDelta:delta];
            });
        });
    });
    describe(@"-nice()", ^{
        void (^domainNiceThat)(NSArray *, NSArray *) = ^(NSArray *domain, NSArray *result) {
            ArsScaleLinear *scaleLinear = [[ArsScaleLinear alloc] init];
            scaleLinear.domain = domain;
            scaleLinear.nice();
            [[scaleLinear.domain should] equal:result];
        };
        void (^domainNiceByStepThat)(NSArray *, NSArray *, NSUInteger) = ^(NSArray *domain, NSArray *result, NSUInteger step) {
            ArsScaleLinear *scaleLinear = [[ArsScaleLinear alloc] init];
            scaleLinear.domain = domain;
            scaleLinear.niceByStep(step);
            [[scaleLinear.domain should] equal:result];
        };
        it(@"nices the domain, extending it to round numbers", ^{
            domainNiceThat(@[@1.1, @10.9], @[@1, @11]);
            domainNiceThat(@[@10.9, @1.1], @[@11, @1]);
            domainNiceThat(@[@123.1, @6.7], @[@130, @0]);
            domainNiceThat(@[@0, @0.49], @[@0, @0.5]);
        });
        it(@"has no effect on degenerate domains", ^{
            domainNiceThat(@[@0, @0], @[@0, @0]);
            domainNiceThat(@[@0, @0.5], @[@0, @0.5]);
        });
        context(@"when has a argument", ^{
            it(@"accepts a tick count to control nicing step", ^{
                domainNiceByStepThat(@[@12, @87], @[@0, @100], 5);
                domainNiceByStepThat(@[@10, @87], @[@10, @90], 10);
                domainNiceByStepThat(@[@12, @87], @[@12, @87], 100);
            });
        });
    });
    describe(@"-ticks", ^{
        beforeEach(^{
            linear.domain = @[@2, @-1];
        });
        it(@"generates ticks of varying degree", ^{
            NSArray *array = [linear ticks:16];
            NSLog(@"array = %@", array);
        });
    });
    SPEC_END