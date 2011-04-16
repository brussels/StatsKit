//
//  SKMeter.m
//  StatsKit
//
//  Created by brussels on 4/13/11.
//  Copyright 2011 brussels. All rights reserved.
//

#import "SKMeter.h"


@implementation SKMeter

- (id)init {
    return [self initWithName:nil];
}

- (id)initWithName:(NSString *)name {
    if ((self = [super init])) {
        _count = 0;
        _startTime = CFAbsoluteTimeGetCurrent();
        _name = [name copy];
    }
    return self;
}

- (void)dealloc {
    [_name release];
    [super dealloc];
}

- (NSUInteger)mark {
    return [self markCount:1];
}

- (NSUInteger)markCount:(NSUInteger)count {
    NSAssert(NSUIntegerMax - _count > count, @"Meter %@ overflowed", _name);
    
    return (_count += count);
}

- (NSUInteger)unmark {
    return [self unmarkCount:1];
}

- (NSUInteger)unmarkCount:(NSUInteger)count {
    NSAssert(count <= _count, @"Meter %@ underflowed", _name);
    
    return (_count -= count);
}

- (NSUInteger)count {
    return _count;
}

- (double)rate {
    CFAbsoluteTime delta = CFAbsoluteTimeGetCurrent() - _startTime;
    return (double)_count / delta;
}

@end
