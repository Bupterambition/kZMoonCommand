//
//  TestkZMoonResult.h
//  kZMoonCommand
//
//  Created by BupterAmbition on 16/8/15.
//  Copyright © 2016年 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <kZMoonCommand/kZMoonResult.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
@interface TestkZMoonResult : NSObject<kZMoonResult>
+ (instancetype)resultWithSubscriber:(id<RACSubscriber>)subscriber;
- (instancetype)initWithSubscriber:(id<RACSubscriber>)subscriber;
@end
