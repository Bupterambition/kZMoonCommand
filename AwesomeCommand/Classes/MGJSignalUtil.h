//
// Created by Wentong on 16/5/31.
//

#import <Foundation/Foundation.h>

@class RACSignal;
@class MGJAwesomeCommand;

@interface MGJSignalUtil : NSObject

+ (RACSignal *)createSignal:(MGJAwesomeCommand *)command;

@end