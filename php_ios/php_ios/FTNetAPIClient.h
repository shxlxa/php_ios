//
//  FTNetAPIClient.h
//  MyProject
//
//  Created by aoni on 17/3/29.
//  Copyright © 2017年 aoni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef void(^SuccessBlock)(id responsObject);
typedef void(^FailBlock)(NSError *error);

typedef void(^DownloadedPathBlock)(NSString *);

typedef enum {
    Get = 0,
    Post,
    Put,
    Delete
} NetworkMethod;

//NS_ENUM，定义状态等普通枚举
typedef NS_ENUM(NSUInteger, DownloadType) {
    DownloadTypeImage = 0,
    DownloadTypeVideo,
    DownloadTypeEvent
};

@interface FTNetAPIClient : NSObject

@property (nonatomic, assign) BOOL isConnected;

@property (nonatomic, copy)   DownloadedPathBlock  downloadedPathBlock;


//单例
+ (FTNetAPIClient *)sharedInstance;


/**
 取消所有请求
 */
- (void)cancelAllRequest;

/**
 *  get请求
 *
 *  @param url     url
 *  @param success success block
 *  @param fail    fail block
 */
- (void)getRequestDataWithUrl:(NSString *)url success:(SuccessBlock)success fail:(FailBlock)fail;

/**
 *  post请求
 *
 *  @param url     url
 *  @param para    param
 *  @param success success block
 *  @param fail    fail block
 */
- (void)postRequestDataWithUrl:(NSString *)url param:(NSDictionary *)para success:(SuccessBlock)success fail:(FailBlock)fail;

//下载进度
@property (nonatomic, assign) double downloadProgress;

/**
 下载文件
 
 @param path     下载路径
 @param success  success block
 @param fail     fail block
 */
- (void)downloadFile:(NSString *)path
             success:(SuccessBlock)success
                fail:(FailBlock)fail;

- (void)cancelDownload;


//下载进度
@property (nonatomic, assign) double uploadProgress;

/**
 上传文件
 
 @param filePath    本地文件路径
 @param path    服务器路径
 @param success     success block
 @param fail        fail block
 */
- (void)uploadFile:(NSString *)filePath
              WithPath:(NSString *)path
               success:(SuccessBlock)success
                  fail:(FailBlock)fail;



/**
 取消上传
 */
- (void)cancelUploadFile;


/**
 上传图片
 
 @param image 要上传的图片
 @param path 上传路径
 @param success 成功回调
 @param fail 失败回调
 */
- (void)uploadImage:(UIImage *)image
           WithPath:(NSString *)path
            success:(SuccessBlock)success
               fail:(FailBlock)fail;


/**
 上传视频
 
 @param videoPath 视频path
 @param path 服务器path
 @param success 成功回调
 @param fail 失败回调
 */
- (void)uploadVideo:(NSString *)videoPath
           WithPath:(NSString *)path
            success:(SuccessBlock)success
               fail:(FailBlock)fail;

@end
