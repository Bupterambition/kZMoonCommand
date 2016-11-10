//
// Created by BupterAmbition on 16/5/31.
//

#import <Foundation/Foundation.h>

@protocol kZMoonEasyResult <NSObject>

@required
- (void)onSuccess:(id)data;
- (void)onError:(NSError *)error;

@end


@protocol kZMoonResult <NSObject>

@required
- (void)onNext:(id)data;
- (void)onComplete;
- (void)onError:(NSError *)error;
- (id<kZMoonEasyResult>)useEasyResult;

@end
