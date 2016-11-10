//
// Created by  on 16/5/31.
//

#import <Foundation/Foundation.h>

@protocol AwesomeEasyResult <NSObject>

@required
- (void)onSuccess:(id)data;
- (void)onError:(NSError *)error;

@end


@protocol AwesomeResult <NSObject>

@required
- (void)onNext:(id)data;
- (void)onComplete;
- (void)onError:(NSError *)error;
- (id<AwesomeEasyResult>)useEasyResult;

@end
