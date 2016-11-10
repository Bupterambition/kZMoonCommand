//
//  TestkZMoonResult.m
//  kZMoonCommand
//
//  Created by BupterAmbition on 16/8/15.
//  Copyright © 2016年 . All rights reserved.
//

#import "TestAwesomeResult.h"
@interface TestkZMoonResult()
@property (nonatomic, strong) id<RACSubscriber> subscriber;
@end

@implementation TestkZMoonResult
@synthesize subscriber = _subscriber;
- (void)onNext:(id)data {
    [_subscriber sendNext:data];
}

- (void)onComplete {
    [_subscriber sendCompleted];
    
}

- (void)onError:(NSError *)error {
    [_subscriber sendError:error];
}

- (id<kZMoonEasyResult>)useEasyResult {
    return nil;
}

+ (instancetype)resultWithSubscriber:(id<RACSubscriber>)subscriber {
    return [[self alloc] initWithSubscriber:subscriber];
    
}
- (instancetype)initWithSubscriber:(id<RACSubscriber>)subscriber {
    self = [super init];
    if (self) {
        _subscriber = subscriber;
    }
    return self;
}
@end
