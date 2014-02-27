//
// Created by azu on 2014/02/26.
//


#import <Foundation/Foundation.h>


@interface ArsTickRange : NSObject
@property(nonatomic) NSNumber *start;
@property(nonatomic) NSNumber *stop;
@property(nonatomic) NSNumber *step;

- (instancetype)initWithStart:(NSNumber *) start stop:(NSNumber *) stop;

+ (instancetype)rangeWithStart:(NSNumber *) start stop:(NSNumber *) stop;

@end