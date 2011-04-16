//
//  SKSample.m
//  StatsKit
//
//  Created by brussels on 4/14/11.
//  Copyright 2011 brussels. All rights reserved.
//

#import "SKSample.h"


@implementation SKSample

- (id)init {
    return [self initWithName:nil window:kSampleWindowUnlimited];
}

- (id)initWithWindow:(NSUInteger)window {
    return [self initWithName:nil window:window];
}

- (id)initWithName:(NSString *)name window:(NSUInteger)window {
    if ((self = [super init])) {
        _sampleCount = 0;
        if (window == kSampleWindowUnlimited) {
            _sampleWindow = 1024;
            _growing = YES;
        } else {
            _sampleWindow = window;
            _growing = NO;
        }
        _samples = malloc(_sampleWindow * sizeof(double));
        _sorted = NO;
        _name = [name copy];
    }
    
    return self;
}

- (void)dealloc {
    free(_samples);
    [_name release];
    [super dealloc];
}

- (void)add:(double)value {
    if (_sampleCount >= _sampleWindow) {
        if (_growing) {
            _sampleWindow = _sampleWindow * 2;
            _samples = realloc(_samples, _sampleWindow * sizeof(double));
            _samples[_sampleCount] = value;
        } else {
            NSUInteger d = drand48() * _sampleCount;
            if (d < _sampleWindow) {
                _samples[d] = value;
            }
        }
    } else {
        _samples[_sampleCount] = value;
    }
    _sampleCount++;
    _sorted = NO;
}

- (void)clear {
    _sampleCount = 0;
    _sorted = NO;
}

static int _compare(const void *lhs, const void *rhs) {
    return (*(double*)lhs > *(double*)rhs);
}

- (void)sort {
    if (!_sorted) {
        qsort(_samples, [self count], sizeof(double), _compare);
        _sorted = YES;
    }
}

- (double)get:(NSUInteger)i {
    NSAssert(i < [self count], @"Index %d out of bounds (%d)", i, _sampleCount);
    return _samples[i];
}

- (size_t)count {
    return (_sampleCount < _sampleWindow ? _sampleCount : _sampleWindow);
}

- (double)median {
    return [self percentile:50];
}

- (double)min {
    return [self percentile:0];
}

- (double)max {
    return [self percentile:100];
}

- (double)mean {
    NSAssert(_sampleCount > 0, @"Sample pool is empty");

    double mean = 0.0f;
    for (NSUInteger i = 0; i < [self count]; i++) {
        mean += _samples[i];
    }
    
    return mean / [self count];
}

- (double)percentile:(unsigned int)group {
    NSAssert(group >= 0 && group <= 100, @"Percentile group must be between [0, 100]");
    NSAssert([self count] > 0, @"Sample pool is empty");

    [self sort];
    
    if (group == 0) return _samples[0];
    if (group == 100) return _samples[[self count]-1];
    return _samples[(group * [self count]) / 100];
}

- (double)standardDevation {
    NSAssert(_sampleCount > 0, @"No data has been taken");
    
    double mean = [self mean];
    double stdDev = 0.0f;
    for (NSUInteger i = 0; i < [self count]; i++) {
        double term = _samples[i] - mean;
        term *= term;
        
        stdDev += term / [self count];
    }
    return sqrt(stdDev);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ min %f max %f mean %f median %f stddev %f", [super description], [self min], [self max], [self mean], [self median], [self standardDevation]];
}

@end
