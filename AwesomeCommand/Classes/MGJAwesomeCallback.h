//
// Created by Senmiao on 16/5/31.
//

#import <Foundation/Foundation.h>

@class MGJAwesomeCommand;

@protocol MGJAwesomeCallback <NSObject>

@required
- (void)onNext:(MGJAwesomeCommand *)command AndData:(id)data;
- (void)onComplete:(MGJAwesomeCommand *)command;
- (void)onError:(MGJAwesomeCommand *)command AndError:(NSError *)error;

@end