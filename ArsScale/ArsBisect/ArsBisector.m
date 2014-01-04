//
// Created by azu on 2014/01/05.
//


#import "ArsBisector.h"


@implementation ArsBisector {

}
+ (NSUInteger)bisectRight:(id) anObject inArray:(NSArray *) array {
    NSUInteger low = 0;
    NSUInteger high = array.count;
    return [self bisectRight:anObject inArray:array low:low hight:high];
}

+ (NSUInteger)bisectRight:(id) anObject inArray:(NSArray *) array low:(NSUInteger) low hight:(NSUInteger) high {
    NSUInteger middle = (low + high) / 2;
    while (low < high) {
        NSComparisonResult comparison = [anObject compare:[array objectAtIndex:middle]];
        if (comparison == NSOrderedAscending) {
            high = middle;
        } else {
            low = middle + 1;
        }
    }
    return low;
}

@end