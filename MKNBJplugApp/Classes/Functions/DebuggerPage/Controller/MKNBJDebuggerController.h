//
//  MKNBJDebuggerController.h
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/19.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseViewController.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKNBJDebuggerController : MKBaseViewController

/// 当前设备的mac地址
@property (nonatomic, copy)NSString *macAddress;

/// 设备退出debug模式
@property (nonatomic, copy)void (^deviceExitDebugModeBlock)(void);

@end

NS_ASSUME_NONNULL_END
