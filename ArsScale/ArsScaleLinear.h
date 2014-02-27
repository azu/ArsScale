//
// Created by azu on 2014/01/04.
//


#import <Foundation/Foundation.h>
#import "ArsScale.h"

@class ArsBisector;
@class ArsTickRange;

@interface ArsScaleLinear : ArsScale
// extend the scale domain to nice round numbers.
// @see https://github.com/mbostock/d3/wiki/Quantitative-Scales#wiki-linear_nice
// @example `linear.nice()`
- (void (^)(void))nice;

// @example `linear.niceByStep(10)`
- (void (^)(NSUInteger))niceByStep;

// enable or disable clamping of the output range.
// @see https://github.com/mbostock/d3/wiki/Quantitative-Scales#wiki-linear_clamp
@property(nonatomic, getter=isClamp) BOOL clamp;
#pragma mark - block
@property(nonatomic, copy) ArsInterpolate interpolate;
@property(nonatomic, copy) ArsUninterpolate uninterpolate;
#pragma mark - produce


- (NSNumber *)scale:(NSNumber *) number;

// invert scale
- (NSNumber *)invert:(NSNumber *) number;
@end