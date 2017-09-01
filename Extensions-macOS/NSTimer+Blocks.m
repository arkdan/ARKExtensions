//
//  ARKExtensions.h
//  NSTimer+Blocks.m
//
//  Created by ark dan on 11/16/16.
//  Copyright © 2016 arkdan. All rights reserved.
//


#import "NSTimer+Blocks.h"

@implementation NSTimer (Blocks)

+ (instancetype)ssscheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval repeats:(BOOL)repeats
                                           block:(void (^)(NSTimer *))block
{
    void (^copy)(void) = [block copy];
    NSTimer *timer = [self scheduledTimerWithTimeInterval:timeInterval
                                                   target:self
                                                 selector:@selector(onTimer:)
                                                 userInfo:copy
                                                  repeats:repeats];
    return timer;
}

+ (instancetype)tttimerWithTimeInterval:(NSTimeInterval)timeInterval repeats:(BOOL)repeats
                                  block:(void (^)(NSTimer *))block
{
    void (^copy)(void) = [block copy];
    NSTimer *timer = [self timerWithTimeInterval:timeInterval
                                          target:self
                                        selector:@selector(onTimer:)
                                        userInfo:copy
                                         repeats:repeats];
    return timer;
}

+ (void)onTimer:(NSTimer *)timer
{
    void (^block)(NSTimer *) = (void (^)(NSTimer *))timer.userInfo;
    if (block)
        block(timer);
}

@end
