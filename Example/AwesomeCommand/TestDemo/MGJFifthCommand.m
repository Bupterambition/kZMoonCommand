//
//  MGJFifthCommand.m
//  AwesomeCommand
//
//  Created by Senmiao on 16/8/15.
//  Copyright © 2016年 wentong. All rights reserved.
//

#import "MGJFifthCommand.h"
#import <AwesomeCommand/MGJAwesomeCommandPublicHeader.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MGJTestAwesomeResult.h"
@implementation MGJFifthCommand {
    MGJTestAwesomeResult *awesomeResult;
}
- (id<MGJAwesomeCancelable>)run:(id<MGJAwesomeResult>)result {
    //Todo Logic Segment
    NSOperation __block *disposeOperation;
    id<MGJAwesomeCancelable> __block superDisposableObject;
    RACSubject *subject = [RACSubject new];
    [subject subscribeNext:^(id x) {
        NSLog(@"开始执行 Command 5");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [result onNext:@"Hello, world."];
            [result onComplete];
        });
        disposeOperation = [NSOperation new];
    }];
    awesomeResult = [MGJTestAwesomeResult resultWithSubscriber:subject];
    superDisposableObject = [super run:(awesomeResult)];
    
    return [[MGJBlockCancelable alloc] initWithBlock:^{
        [superDisposableObject cancel];
        [disposeOperation cancel];
    }];
}

@end
