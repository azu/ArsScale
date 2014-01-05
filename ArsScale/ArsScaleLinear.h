//
// Created by azu on 2014/01/04.
//


#import <Foundation/Foundation.h>
#import "ArsScale.h"

@class ArsBisector;


@interface ArsScaleLinear : ArsScale
@property(nonatomic) BOOL clamp;

#pragma mark - produce
- (NSNumber *)scale:(NSNumber *) number;

- (NSNumber *)invert:(NSNumber *) number;
@end