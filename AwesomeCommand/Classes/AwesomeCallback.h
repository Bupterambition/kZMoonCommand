//
// Created by  on 16/5/31.
//

#import <Foundation/Foundation.h>

@class AwesomeCommand;

@protocol AwesomeCallback <NSObject>

@required
- (void)onNext:(AwesomeCommand *)command AndData:(id)data;
- (void)onComplete:(AwesomeCommand *)command;
- (void)onError:(AwesomeCommand *)command AndError:(NSError *)error;

@end
