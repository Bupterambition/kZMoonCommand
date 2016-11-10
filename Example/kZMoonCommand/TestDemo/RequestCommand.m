//
//  RequestCommand.m
//  kZMoonCommand
//
//  Created by BupterAmbition on 16/8/15.
//  Copyright © 2016年 . All rights reserved.
//

#import "RequestCommand.h"
#import <kZMoonCommand/kZMoonCommandPublicHeader.h>

@implementation RequestCommand

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setExecQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    }
    return self;
}
- (id<kZMoonCancelable>)run:(id<kZMoonResult>)result {
    NSLog(@"开始执行 Command Request");
    NSLog(@"current thread:__%@__",[NSThread currentThread]);
    [result onNext:@"requestCMD1"];
    [result onNext:@"requestCMD2"];
    [result onComplete];
    NSOperation *disposeOperation = [NSOperation new];
    return [[BlockCancelable alloc] initWithBlock:^{
        //something to compose
        //Example
        [disposeOperation cancel];
    }];
}
@end
