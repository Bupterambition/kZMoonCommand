//
//  MGJThirdCommand.m
//  AwesomeCommand
//
//  Created by Senmiao on 16/8/15.
//  Copyright © 2016年 wentong. All rights reserved.
//

#import "MGJThirdCommand.h"
#import <AwesomeCommand/MGJAwesomeCommandPublicHeader.h>

@implementation MGJThirdCommand
- (id<MGJAwesomeCancelable>)run:(id<MGJAwesomeResult>)result {
    NSLog(@"开始执行 Command 3");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [result onNext:nil];
        [result onComplete];
    });
    NSOperation *disposeOperation = [NSOperation new];
    return [[MGJBlockCancelable alloc] initWithBlock:^{
        //something to compose
        //Example
        [disposeOperation cancel];
    }];
}
@end
