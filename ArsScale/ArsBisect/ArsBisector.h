//
// Created by azu on 2014/01/05.
//


#import <Foundation/Foundation.h>


@interface ArsBisector : NSObject
+ (NSUInteger)bisectRight:(id) anObject inArray:(NSArray *) array;

+ (NSUInteger)bisectRight:(id) anObject inArray:(NSArray *) array low:(NSUInteger) low hight:(NSUInteger) high;
@end