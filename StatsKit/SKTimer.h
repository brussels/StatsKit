//
//  SKTimer.h
//  StatsKit
//
//  Created by brussels on 4/13/11.
//  Copyright 2011 brussels. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StatsKit/SKSample.h>

@interface SKTimer : NSObject {
@private
    SKSample *_samples;
    double _total;
    CFAbsoluteTime _startTime;
    NSString *_name;
}

- (id)initWithWindow:(NSUInteger)window;
- (id)initWithName:(NSString *)name window:(NSUInteger)window;

- (double)time:(void (^)())block;

- (double)begin;
- (double)end;

- (double)total;

@property (nonatomic, readonly) SKSample *samples;
@end
