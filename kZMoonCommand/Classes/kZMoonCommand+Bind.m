//
//  kZMoonCommand+Bind.m
//  Pods
//
//  Created by Senmiao on 2016/11/23.
//
//

#import "kZMoonCommand+Bind.h"
#import "kZMoonBindCommand.h"
#import <objc/runtime.h>

const char * BlockArray = "KzMoonCommandPrivateArray";

@interface kZMoonCommand (private)
@property (nonatomic, strong) NSMutableArray <KzMoonBindBlock> *bindBlockArray;
@end

@implementation kZMoonCommand(private)

- (NSMutableArray *)bindBlockArray {
    return objc_getAssociatedObject(self, BlockArray);
}

- (void)setBindBlockArray:(NSMutableArray<KzMoonBindBlock> *)bindBlockArray {
    objc_setAssociatedObject(self, BlockArray, bindBlockArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end


@implementation kZMoonCommand (Bind)
- (__kindof kZMoonCommand *)bind:(KzMoonBindBlock)bindBlock {
    if (!self.bindBlockArray) {
        self.bindBlockArray = [NSMutableArray array];
    }
    [self.bindBlockArray addObject:[bindBlock copy]];
    if (![self isMemberOfClass:[kZMoonBindCommand class]]) {
        kZMoonBindCommand *bind = [[kZMoonBindCommand alloc] initWithCommand:(kZMoonBindCommand *)self];
        bind.bindBlockArray = [self.bindBlockArray mutableCopy];
        return bind;
    }
    return self;
}
@end
