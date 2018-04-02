//
//  Tools.h
//  php_ios
//
//  Created by mac on 2018/1/17.
//  Copyright © 2018年 aoni. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kDocumentsDirectory  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject

@interface Tools : NSObject

+ (NSString *)getDeviceIPAdress;

+ (NSString *)getIPAddress;

+ (NSArray *)getBundleVideoNum;

@end
