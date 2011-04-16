//
//  SKTimer.m
//  StatsKit
//
//  Created by brussels on 4/13/11.
//  Copyright 2011 brussels. All rights reserved.
//

#import "SKTimer.h"


@implementation SKTimer

@synthesize samples=_samples;

- (id)init {
    return [self initWithName:nil window:kSampleWindowUnlimited];
}

- (id)initWithWindow:(NSUInteger)window {
    return [self initWithName:nil window:window];
}

- (id)initWithName:(NSString *)name window:(NSUInteger)window {
    if ((self = [super init])) {
        _samples = [[SKSample alloc] initWithName:name window:window];
        _name = [name copy];
        _total = 0.0f;
    }
    
    return self;
}

- (void)dealloc {
    [_samples release];
    [super dealloc];
}

- (double)time:(void (^)())block {
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    block();
    CFAbsoluteTime result = CFAbsoluteTimeGetCurrent() - start;
    
    [_samples add:result];
    _total += result;
    
    return result;
}

- (double)begin {
    _startTime = CFAbsoluteTimeGetCurrent();
    return _startTime;
}

- (double)end {
    CFAbsoluteTime result = CFAbsoluteTimeGetCurrent() - _startTime;
    [_samples add:result];
    _total += result;
    
    return result;
}

- (double)total {
    return _total;
}

- (NSString *)description {
    return [_samples description];
}

@end
