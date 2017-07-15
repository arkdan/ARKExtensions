//
//  ARKExtensions.h
//  NSTimer+Blocks.h
//
//  Created by ark dan on 11/16/16.
//  Copyright © 2016 arkdan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Blocks)

/// The funny name, so it won't conflict with newly added same methods in Foundation iOS10 & macOS 10.12
/// This is here for older systems
+ (instancetype)ssscheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval repeats:(BOOL)repeats
                                           block:(void (^)(NSTimer *))block;
+ (instancetype)tttimerWithTimeInterval:(NSTimeInterval)timeInterval repeats:(BOOL)repeats
                                  block:(void (^)(NSTimer *))block;
@end
