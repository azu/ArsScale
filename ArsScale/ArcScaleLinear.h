//
// Created by azu on 2014/01/04.
//


#import <Foundation/Foundation.h>
#import "ArsScale.h"


@interface ArcScaleLinear : ArsScale
#pragma mark - produce
- (NSNumber *)scale:(NSNumber *) number;

- (NSNumber *)invert:(NSNumber *) number;
@end