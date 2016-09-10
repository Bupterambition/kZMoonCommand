//
//  MGJFirstCommand.m
//  AwesomeCommand
//
//  Created by Senmiao on 16/8/15.
//  Copyright © 2016年 wentong. All rights reserved.
//

#import "MGJFirstCommand.h"
#import <AwesomeCommand/MGJAwesomeCommandPublicHeader.h>
@implementation MGJFirstCommand
@synthesize excuteQueue = _excuteQueue;
- (instancetype)init {
    self = [super init];
    if (self) {
        _excuteQueue = dispatch_get_global_queue(0, 0);
    }
    return self;
}


- (id<MGJAwesomeCancelable>)run:(id<MGJAwesomeResult>)result {
    NSLog(@"开始执行 Command 1");
    [result onNext:@"1"];
    [result onComplete];
    NSOperation *disposeOperation = [NSOperation new];
    return [[MGJBlockCancelable alloc] initWithBlock:^{
        //something to compose
        //Example
        [disposeOperation cancel];
    }];
}

@end
