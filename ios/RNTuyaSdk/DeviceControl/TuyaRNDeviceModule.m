//
//  TuyaRNDeviceModule.m
//  TuyaRnDemo
//
//  Created by 浩天 on 2019/2/28.
//  Copyright © 2019年 Facebook. All rights reserved.
//

#import "TuyaRNDeviceModule.h"
#import "TuyaRNDeviceListener.h"
#import <ThingSmartDeviceKit/ThingSmartDeviceKit.h>
#import "ThingSmartBLELockDevice.h"
#import "ThingSmartBLELockMemberModel.h"
#import "TuyaRNUtils.h"
#import "YYModel.h"


#define kTuyaDeviceModuleDevId @"devId"
#define kTuyaDeviceModuleCommand @"command"
#define kTuyaDeviceModuleDpId @"dpId"
#define kTuyaDeviceModuleDeviceName @"name"

@interface TuyaRNDeviceModule()

@property (strong, nonatomic) ThingSmartDevice *smartDevice;
@property (nonatomic, strong) ThingSmartBLELockDevice *lock;

@end

@implementation TuyaRNDeviceModule

RCT_EXPORT_MODULE(TuyaDeviceModule)

/**
 设备监听开启
 */
RCT_EXPORT_METHOD(registerDevListener:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    ThingSmartDevice *d = [self smartDeviceWithParams:params];
    if (d == nil) {
        rejecter(@"cannot add device listener", @"devId is nil or not exist", nil);
    } else {
        //监听设备
        [TuyaRNDeviceListener registerDevice:d type:TuyaRNDeviceListenType_DeviceInfo];
    }
}

/**
 设备监听删除

 */
RCT_EXPORT_METHOD(unRegisterDevListener:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    NSString *deviceId = params[kTuyaDeviceModuleDevId];
    if(deviceId.length == 0) {
        return;
    }

    ThingSmartDevice *device = [ThingSmartDevice deviceWithDeviceId:deviceId];

    // 移除监听设备
    [TuyaRNDeviceListener removeDevice:device type:TuyaRNDeviceListenType_DeviceInfo];

    self.smartDevice  = [self smartDeviceWithParams:params];
    //取消设备监听
    [TuyaRNDeviceListener removeDevice:self.smartDevice type:TuyaRNDeviceListenType_DeviceInfo];
}


/*
 * 通过局域网或者云端这两种方式发送控制指令给设备。send(通过局域网或者云端这两种方式发送控制指令给设备。)
 command的格式应符合{key:value} 例如 {"1":true}
 */
RCT_EXPORT_METHOD(send:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    //设备发送消息
    self.smartDevice  = [self smartDeviceWithParams:params];

    NSDictionary *command = params[kTuyaDeviceModuleCommand];
    [self.smartDevice publishDps:command success:^{
        [TuyaRNUtils resolverWithHandler:resolver];
    } failure:^(NSError *error) {
        NSLog(@"send failure %@", error);
        [TuyaRNUtils rejecterWithError:error handler:rejecter];
    }];
}

/**
 查询单个dp数据
 */
RCT_EXPORT_METHOD(getDp:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {

    NSString *dpId = params[kTuyaDeviceModuleDpId];
    //读取dp点
    self.smartDevice  = [self smartDeviceWithParams:params];
    if (self.smartDevice) {
        if (resolver) {
            resolver(self.smartDevice.deviceModel.dps[dpId]?:@"");
        }
    }
}


/**
 设备重命名
 */
RCT_EXPORT_METHOD(renameDevice:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {

    self.smartDevice  = [self smartDeviceWithParams:params];
    NSString *deviceName = params[kTuyaDeviceModuleDeviceName];
    [self.smartDevice updateName:deviceName success:^{
        [TuyaRNUtils resolverWithHandler:resolver];
    } failure:^(NSError *error) {
        [TuyaRNUtils rejecterWithError:error handler:rejecter];
    }];
}

// 更新单个设备信息:
//RCT_EXPORT_METHOD(getDp:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
//    ThingSmartDevice *device = [ThingSmartDevice deviceWithDeviceId:params[@"devId"]];
//    [device syncWithCloud:^{
//      if (resolver) {
//        resolver(@"syncWithCloud success");
//      }
//    } failure:^(NSError *error) {
//        [TuyaRNUtils rejecterWithError:error handler:rejecter];
//    }];
//}


RCT_EXPORT_METHOD(getDataPointStat:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    self.smartDevice  = [self smartDeviceWithParams:params];
}


/**
 删除设备
 */
RCT_EXPORT_METHOD(removeDevice:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {

    self.smartDevice  = [self smartDeviceWithParams:params];
    [self.smartDevice remove:^{
        [TuyaRNUtils resolverWithHandler:resolver];
    } failure:^(NSError *error) {
        [TuyaRNUtils rejecterWithError:error handler:rejecter];
    }];
}

// 设备重命名：已验证
//RCT_EXPORT_METHOD(renameDevice:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
//
//    ThingSmartDevice *device = [ThingSmartDevice deviceWithDeviceId:params[@"devId"]];
//    [device updateName:params[@"name"] success:^{
//      if (resolver) {
//        resolver(@"rename success");
//      }
//    } failure:^(NSError *error) {
//        [TuyaRNUtils rejecterWithError:error handler:rejecter];
//    }];
//}


RCT_EXPORT_METHOD(onDestroy:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {

}

// 下发升级指令：
RCT_EXPORT_METHOD(startOta:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    ThingSmartDevice *device = [ThingSmartDevice deviceWithDeviceId:params[@"devId"]];
    [device upgradeFirmware:[params[@"type"] integerValue] success:^{
        if (resolver) {
            resolver(@"success");
        }
    } failure:^(NSError *error) {
        [TuyaRNUtils rejecterWithError:error handler:rejecter];
    }];
}

// 查询固件升级信息：
RCT_EXPORT_METHOD(getOtaInfo:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {

    ThingSmartDevice *device = [ThingSmartDevice deviceWithDeviceId:params[@"devId"]];
    [device getFirmwareUpgradeInfo:^(NSArray<ThingSmartFirmwareUpgradeModel *> *upgradeModelList) {

        NSMutableArray *res = [NSMutableArray array];
        for (ThingSmartFirmwareUpgradeModel *item in upgradeModelList) {
            NSDictionary *dic = [item yy_modelToJSONObject];
            [res addObject:dic];
        }
        if (resolver) {
            resolver(res);
        }

        NSLog(@"getFirmwareUpgradeInfo success");
    } failure:^(NSError *error) {
        [TuyaRNUtils rejecterWithError:error handler:rejecter];
    }];

}

RCT_EXPORT_METHOD(getProLockMemberListWithDevId:(NSString *)devId resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    ThingSmartBLELockDevice *lock = [ThingSmartBLELockDevice deviceWithDeviceId:devId];
    [lock getProLockMemberListWithDevId:devId success:^(NSArray<ThingSmartBLELockMemberModel *> * _Nonnull list) {
        NSMutableArray *memberList = [NSMutableArray array];

        for (ThingSmartBLELockMemberModel *member in list) {
            NSDictionary *dic = [member yy_modelToJSONObject];
            [memberList addObject:dic];
        }
        if (resolver) {
            resolver(memberList);
        }
    } failure:^(NSError *error) {
        [TuyaRNUtils rejecterWithError:error handler:rejecter];
    }];
}

RCT_EXPORT_METHOD(getProCurrentMemberDetailWithDevId:(NSString *)devId resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    ThingSmartBLELockDevice *lock = [ThingSmartBLELockDevice deviceWithDeviceId:devId];
    [lock getProCurrentMemberDetailWithDevId:devId success:^(NSDictionary *dict) {
        NSString *bleUnlock = [dict objectForKey:@"lockUserId"];
        NSLog(@"bleUnlock: %@", bleUnlock);
        [lock bleUnlock:bleUnlock success:^{
            NSLog(@"Door is unlocked");
        } failure:^(NSError *error) {
            NSLog(@"Failed to unlock the door with error: %@", error);
        }];
    } failure:^(NSError *error) {
        NSLog(@"bleCurrentMemberDetailWithDevId failure!");
    }];
}

RCT_EXPORT_METHOD(getProUnboundUnlockOpModeListWithDevId:(NSString *)devId resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
   ThingSmartBLELockDevice *lock = [ThingSmartBLELockDevice deviceWithDeviceId:devId];
   [lock getProUnboundUnlockOpModeListWithDevId:devId
      success:^(id result) {
       NSLog(@"getProUnboundUnlockOpModeListWithDevId: %@", result);
   } failure:^(NSError *error) {
       NSLog(@"getProUnboundUnlockOpModeListWithDevId ERROR: %@", error);
   }];
}

RCT_EXPORT_METHOD(getProBoundUnlockOpModeListWithDevId:(NSString *)devId :(NSString *)userId resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
  ThingSmartBLELockDevice *lock = [ThingSmartBLELockDevice deviceWithDeviceId:devId];
  [lock getProBoundUnlockOpModeListWithDevId:devId
    userId:userId
    success:^(id result) {
      NSLog(@"List request succeeds with result: %@", result);
    } failure:^(NSError *error) {
      NSLog(@"List request fails");
    }];
}

RCT_EXPORT_METHOD(isProNeedAllocUnlockOpMode:(NSString *)devId resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
  ThingSmartBLELockDevice *lock = [ThingSmartBLELockDevice deviceWithDeviceId:devId];
  [lock isProNeedAllocUnlockOpModeWithDevId:devId
    success:^(id result) {
      NSLog(@"isProNeedAllocUnlockOpMode: %@", result);
    } failure:^(NSError *error) {
      NSLog(@"isProNeedAllocUnlockOpMode fails");
    }];
}

RCT_EXPORT_METHOD(getProOfflinePasswordWithDevId:(NSString *)devId resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    ThingSmartBLELockDevice *lock = [ThingSmartBLELockDevice deviceWithDeviceId:devId];
    [lock getProOfflinePasswordWithDevId:devId
        pwdType:@"1"
        gmtStart:0
        gmtExpired:0
        pwdName:@"Pro One-time password1"
        success:^(id result) {
          NSLog(@"***********Time-limited password for pro locks -> Success: %@", result);
        } failure:^(NSError *error) {
          NSLog(@"Error %@", error);
        }];
}

RCT_EXPORT_METHOD(getLockDynamicPasswordWithSuccess:(NSString *)devId resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    ThingSmartBLELockDevice *lock = [ThingSmartBLELockDevice deviceWithDeviceId:devId];
    [lock getLockDynamicPasswordWithSuccess:^(NSString *result) {
        resolver(result);
        NSLog(@"getLockDynamicPasswordWithSuccess -> Success: %@", result);
    } failure:^(NSError *error) {
        NSLog(@"Error %@", error);
    }];
}

RCT_EXPORT_METHOD(getProPasswordListWithDevId:(NSString *)devId resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    ThingSmartBLELockDevice *lock = [ThingSmartBLELockDevice deviceWithDeviceId:devId];
    [lock getProPasswordListWithDevId:lock.deviceModel.devId
      authTypes:@[@"LOCK_OFFLINE_TEMP_PWD"]
      success:^(id result) {
        NSLog(@"List query succeeds with result: %@", result);
      } failure:^(NSError *error) {
        NSLog(@"List query fails with error: %@", error);
      }];
}

RCT_EXPORT_METHOD(addMemberWithUserName:(NSString *)devId :(NSString *)date resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    ThingSmartBLELockDevice *lock = [ThingSmartBLELockDevice deviceWithDeviceId:devId];
    [lock addMemberWithUserName:@"aptly-lock-member" allowUnlock:YES timeType:ThingMemberTimeTypePhase effectiveDate:[NSDate date] invalidDate:[[NSDate date] dateByAddingTimeInterval:60 * 60 * 8] success:^(BOOL result) {
        NSLog(@"Lock member created.");
    } failure:^(NSError *error) {
        NSLog(@"Failed to create lock member, error: %@", error);
    }];
}



RCT_EXPORT_METHOD(checkIsBLEConnected:(NSString *)devId resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    ThingSmartBLELockDevice *lock = [ThingSmartBLELockDevice deviceWithDeviceId:devId];
    BOOL isConnected = [lock isBLEConnected];
    if(!isConnected){
     [lock autoConnect];
    }
    resolver(@(isConnected));
}

RCT_EXPORT_METHOD(checkIsOnline:(NSString *)devId resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    ThingSmartBLELockDevice *lock = [ThingSmartBLELockDevice deviceWithDeviceId:devId];
    BOOL isOnline = [lock isOnline];
    resolver(@(isOnline));
}

RCT_EXPORT_METHOD(bleManualLockDevice:(NSString *)devId resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    ThingSmartBLELockDevice *lock = [ThingSmartBLELockDevice deviceWithDeviceId:devId];
    [lock bleManualLock:^{
        resolver(@"bleManualLock success!");
        NSLog(@"bleManualLock success!");
    } failure:^(NSError *error) {
        NSLog(@"bleManualLock failure: %ld", error.code);
    }];
}


#pragma mark -
- (ThingSmartDevice *)smartDeviceWithParams:(NSDictionary *)params {
  NSString *deviceId = params[kTuyaDeviceModuleDevId];
  if(deviceId.length == 0) {
    return nil;
  }
  return [ThingSmartDevice deviceWithDeviceId:deviceId];
}


@end
