//
//  FourthCommand.m
//  kZMoonCommand
//
//  Created by BupterAmbition on 16/8/15.
//  Copyright © 2016年 . All rights reserved.
//

#import "FourthCommand.h"
#import <kZMoonCommand/kZMoonCommandPublicHeader.h>

@implementation FourthCommand
- (id<kZMoonCancelable>)run:(id<kZMoonResult>)result {
    NSLog(@"开始执行 Command 4");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [result onNext:nil];
        [result onComplete];
    });
    NSOperation *disposeOperation = [NSOperation new];
    return [[BlockCancelable alloc] initWithBlock:^{
        //something to compose
        //Example
        [disposeOperation cancel];
    }];
}
@end
