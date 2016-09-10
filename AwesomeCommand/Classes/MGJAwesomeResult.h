//
// Created by Zephyrleaves on 16/5/31.
//

#import <Foundation/Foundation.h>

@protocol MGJAwesomeEasyResult <NSObject>

@required
- (void)onSuccess:(id)data;
- (void)onError:(NSError *)error;

@end


@protocol MGJAwesomeResult <NSObject>

@required
- (void)onNext:(id)data;
- (void)onComplete;
- (void)onError:(NSError *)error;
- (id<MGJAwesomeEasyResult>)useEasyResult;

@end