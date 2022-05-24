//
//  MKNBJImportServerController.h
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/5/5.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseViewController.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKNBJImportServerControllerDelegate <NSObject>

- (void)nbj_selectedServerParams:(NSString *)fileName;

@end

@interface MKNBJImportServerController : MKBaseViewController

@property (nonatomic, weak)id <MKNBJImportServerControllerDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
