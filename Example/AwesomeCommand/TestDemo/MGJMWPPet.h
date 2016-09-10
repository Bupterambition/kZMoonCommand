//
//  MGJMWPPet.h
//  AwesomeCommand
//
//  Created by Derek Chen on 8/26/16.
//  Copyright © 2016 wentong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGJMWPPet : NSObject

@property(nonatomic, copy) NSString *name;
@property(nonatomic, assign) NSInteger age;
@property(nonatomic, assign) NSInteger weight;
@property(nonatomic, assign) NSInteger height;
@property(nonatomic, copy) NSString *desc;
@property(nonatomic, assign) BOOL pt;

@end
