//
//  MKNBJPeripheral.h
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/13.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MKBaseBleModule/MKBLEBaseDataProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@class CBPeripheral;
@interface MKNBJPeripheral : NSObject<MKBLEBasePeripheralProtocol>

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral;

@end

NS_ASSUME_NONNULL_END
