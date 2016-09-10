//
//  MGJTestAwesomeResult.h
//  AwesomeCommand
//
//  Created by Senmiao on 16/8/15.
//  Copyright © 2016年 wentong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AwesomeCommand/MGJAwesomeResult.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
@interface MGJTestAwesomeResult : NSObject<MGJAwesomeResult>
+ (instancetype)resultWithSubscriber:(id<RACSubscriber>)subscriber;
- (instancetype)initWithSubscriber:(id<RACSubscriber>)subscriber;
@end
