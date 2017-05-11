//
//  kZMoonCommand+Bind.h
//  Pods
//
//  Created by Senmiao on 2016/11/23.
//
//

#import <kZMoonCommand/kZMoonCommand.h>
NS_ASSUME_NONNULL_BEGIN
@interface kZMoonCommand (Bind)
typedef  kZMoonCommand * _Nullable (^KzMoonBindBlock)(NSUInteger index,id<kZMoonCommand> cmd,_Nullable id data,  NSError * _Nullable error, BOOL isCompleted);
/**
 *  Command Bind Operation
 *
 *  @param bindBlock Binding Handle
 *
 *  @return BindCommand Command that you should retain otherwise the return command will dispose
 */
- (__kindof kZMoonCommand *)bind:(KzMoonBindBlock)bindBlock;
@end
NS_ASSUME_NONNULL_END
