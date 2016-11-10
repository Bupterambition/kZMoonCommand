//
// Created by  on 16/5/31.
//

#import <Foundation/Foundation.h>

@class RACSignal;
@class AwesomeCommand;

@interface SignalUtil : NSObject

+ (RACSignal *)createSignal:(AwesomeCommand *)command;

@end
