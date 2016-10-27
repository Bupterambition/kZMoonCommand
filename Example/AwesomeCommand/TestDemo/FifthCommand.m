//
//  FifthCommand.m
//  AwesomeCommand
//
//  Created by Senmiao on 16/8/15.
//  Copyright © 2016年 wentong. All rights reserved.
//

#import "FifthCommand.h"
#import <AwesomeCommand/AwesomeCommandPublicHeader.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "TestAwesomeResult.h"
@implementation FifthCommand {
    TestAwesomeResult *awesomeResult;
}
- (id<AwesomeCancelable>)run:(id<AwesomeResult>)result {
    //Todo Logic Segment
    NSOperation __block *disposeOperation;
    id<AwesomeCancelable> __block superDisposableObject;
    RACSubject *subject = [RACSubject new];
    [subject subscribeNext:^(id x) {
        NSLog(@"开始执行 Command 5");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [result onNext:@"Hello, world."];
            [result onComplete];
        });
        disposeOperation = [NSOperation new];
    }];
    awesomeResult = [TestAwesomeResult resultWithSubscriber:subject];
    superDisposableObject = [super run:(awesomeResult)];
    
    return [[BlockCancelable alloc] initWithBlock:^{
        [superDisposableObject cancel];
        [disposeOperation cancel];
    }];
}

@end
