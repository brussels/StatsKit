//
//  StatsKitTests.m
//  StatsKitTests
//
//  Created by brussels on 4/16/11.
//  Copyright 2011 brussels. All rights reserved.
//

#import "StatsKitTests.h"


@implementation StatsKitTests

- (void)testMeter {
    SKMeter *meter = [[SKMeter alloc] init];
    STAssertTrue([meter mark] == 1, @"mark test failed");
    STAssertTrue([meter markCount:5] == 6, @"markCount test failed");
    STAssertTrue([meter unmark] == 5, @"unmark test failed");
    STAssertTrue([meter unmarkCount:5] == 0, @"unmarkCount test failed");
    STAssertThrows([meter markCount:NSUIntegerMax], @"overflow test failed");
    STAssertThrows([meter unmarkCount:1], @"underflow test failed");
    STAssertTrue([meter count] == 0, @"count test failed");
    [meter mark];
    usleep(20);
    STAssertTrue([meter rate] > 0.0, @"rate test failed");
    [meter release];
}

- (void)testTimer {
    SKTimer *timer = [[SKTimer alloc] init];
    STAssertTrue([timer total] == 0.0, @"total test failed");
    STAssertTrue([timer time:^{ sleep(1); }] >= 1.0, @"block time test failed");
    STAssertTrue([timer begin] >= 0.0, @"begin test failed");
    sleep(1);
    STAssertTrue([timer end] >= 1.0, @"begin/end test failed");
    STAssertTrue([timer total] > 2.0, @"final total test failed");
    [timer release];
}

- (void)testSamples {
    // growing window tests
    SKSample *sample = [[SKSample alloc] init];
    [sample add:1.0];
    [sample add:2.0];
    [sample add:3.0];
    STAssertTrue([sample count] == 3, @"count test failed");
    STAssertTrue([sample get:0] == 1.0, @"get test failed");
    STAssertTrue([sample min] == 1.0, @"min test failed");
    STAssertTrue([sample median] == 2.0, @"median test failed");
    STAssertTrue([sample max] == 3.0, @"max test failed");
    STAssertEqualsWithAccuracy([sample mean], 2.0, 0.000001, @"mean test failed");
    [sample release];
    
    // fixed window tests
    sample = [(SKSample*)[SKSample alloc] initWithName:nil window:100]; // llvm bug?
    for (int i = 0; i < 200; i++) {
        [sample add:i];
    }
    STAssertTrue([sample count] == 100, @"count with window test failed");
    [sample release];
}


@end
