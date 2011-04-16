//
//  SKSample.h
//  StatsKit
//
//  Created by brussels on 4/14/11.
//  Copyright 2011 brussels. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kSampleWindowUnlimited 0

@interface SKSample : NSObject {
@private
    NSString *_name;
    double *_samples;
    NSUInteger _sampleWindow;
    NSUInteger _sampleCount;
    BOOL _sorted;
    BOOL _growing;
}

- (id)initWithWindow:(NSUInteger)window;
- (id)initWithName:(NSString *)name window:(NSUInteger)window;

- (void)add:(double)value;
- (double)get:(NSUInteger)index;
- (void)clear;
- (NSUInteger)count;

- (double)median;
- (double)min;
- (double)max;
- (double)mean;
- (double)percentile:(unsigned int)group;
- (double)standardDevation;

@end
