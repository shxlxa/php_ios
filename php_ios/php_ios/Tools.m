//
//  Tools.m
//  php_ios
//
//  Created by mac on 2018/1/17.
//  Copyright © 2018年 aoni. All rights reserved.
//

#import "Tools.h"
#import <ifaddrs.h>
#import <arpa/inet.h>

@implementation Tools

+ (NSString *)getDeviceIPAdress{
    NSString *address = nil;
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    success = getifaddrs(&interfaces);
    
    if (success == 0) { // 0 表示获取成功
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    freeifaddrs(interfaces);
    return address;
}

+ (NSString *)getIPAddress{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    
}



+ (NSArray *)getBundleVideoNum{
    NSMutableArray *nums = [NSMutableArray array];
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSString *dir = [kDocumentsDirectory stringByAppendingPathComponent:@"TYDownloadCache"];
    NSArray *files = [fileManage subpathsAtPath:dir];
    for (NSString *fileName in files) {
        if ([fileName.lowercaseString hasSuffix:@"mp4"]) {
            [nums addObject:fileName];
        }
    }
    return nums;
}

@end
