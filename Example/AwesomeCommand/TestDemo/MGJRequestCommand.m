//
//  MGJRequestCommand.m
//  AwesomeCommand
//
//  Created by Senmiao on 16/8/15.
//  Copyright © 2016年 wentong. All rights reserved.
//

#import "MGJRequestCommand.h"
#import <AwesomeCommand/MGJAwesomeCommandPublicHeader.h>

@implementation MGJRequestCommand

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setExecQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    }
    return self;
}
- (id<MGJAwesomeCancelable>)run:(id<MGJAwesomeResult>)result {
    NSLog(@"开始执行 Command Request");
    NSLog(@"current thread:__%@__",[NSThread currentThread]);
    [result onNext:@"requestCMD1"];
    [result onNext:@"requestCMD2"];
    [result onComplete];
    NSOperation *disposeOperation = [NSOperation new];
    return [[MGJBlockCancelable alloc] initWithBlock:^{
        //something to compose
        //Example
        [disposeOperation cancel];
    }];
}
@end
