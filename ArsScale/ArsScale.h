//
//  ArsScale.h
//  ArsScale
//
//  Created by azu on 2014/01/04.
//  Copyright (c) 2014 azu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArsScale : NSObject
#pragma mark - DataSet
/*
    input data array
 */
@property(nonatomic) NSArray *domain;
/*
    output data array
 */
@property(nonatomic) NSArray *range;
@end
