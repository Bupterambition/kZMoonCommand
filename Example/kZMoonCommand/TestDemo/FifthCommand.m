//
//  FifthCommand.m
//  kZMoonCommand
//
//  Created by BupterAmbition on 16/8/15.
//  Copyright © 2016年 . All rights reserved.
//

#import "FifthCommand.h"
#import <kZMoonCommand/kZMoonCommandPublicHeader.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "TestAwesomeResult.h"
@implementation FifthCommand {
    TestkZMoonResult *kZMoonResult;
}
- (id<kZMoonCancelable>)run:(id<kZMoonResult>)result {
    //Todo Logic Segment
    NSOperation __block *disposeOperation;
    id<kZMoonCancelable> __block superDisposableObject;
    RACSubject *subject = [RACSubject new];
    [subject subscribeNext:^(id x) {
        NSLog(@"开始执行 Command 5");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [result onNext:@"Hello, world."];
            [result onComplete];
        });
        disposeOperation = [NSOperation new];
    }];
    kZMoonResult = [TestkZMoonResult resultWithSubscriber:subject];
    superDisposableObject = [super run:(kZMoonResult)];
    
    return [[BlockCancelable alloc] initWithBlock:^{
        [superDisposableObject cancel];
        [disposeOperation cancel];
    }];
}

@end
