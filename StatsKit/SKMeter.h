//
//  SKMeter.h
//  StatsKit
//
//  Created by brussels on 4/13/11.
//  Copyright 2011 brussels. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SKMeter : NSObject {
@private
    NSUInteger _count;
    CFAbsoluteTime _startTime;
    NSString *_name;
}

- (id)init;
- (id)initWithName:(NSString *)name;

- (NSUInteger)mark;
- (NSUInteger)markCount:(NSUInteger)count;
- (NSUInteger)unmark;
- (NSUInteger)unmarkCount:(NSUInteger)count;

- (NSUInteger)count;
- (double)rate;

@end
