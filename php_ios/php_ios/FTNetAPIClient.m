//
//  FTNetAPIClient.m
//  MyProject
//
//  Created by aoni on 17/3/29.
//  Copyright © 2017年 aoni. All rights reserved.
//

#import "FTNetAPIClient.h"
#import "AFNetworking.h"

#define DebugLog(s, ...) NSLog(@"%s(%d): %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])

#define kBaseUrl @"https://coding.net/"

@implementation FTNetAPIClient{
    NSURLSessionDownloadTask *_downloadTask;
    AFURLSessionManager *_manager;
    NSURLSessionDataTask *_uploadTask;
}


typedef NS_ENUM(NSInteger, UploadMediaType) {
    UploadMediaTypeImage,//默认从0开始
    UploadMediaTypeVideo
};

static FTNetAPIClient *netAPIClient;
+ (FTNetAPIClient *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        netAPIClient = [[self alloc] init];
    });
    return netAPIClient;
}

#pragma mark - get请求
- (void)getRequestDataWithUrl:(NSString *)url
                      success:(SuccessBlock)success
                         fail:(FailBlock)fail
{
    [self netRequestData:url withParam:nil withMethodType:Get success:success fail:fail];
}

#pragma mark - post请求
- (void)postRequestDataWithUrl:(NSString *)url
                         param:(NSDictionary *)para
                       success:(SuccessBlock)success
                          fail:(FailBlock)fail
{
    [self netRequestData:url withParam:para withMethodType:Post success:success fail:fail];
}

- (void)cancelAllRequest{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.operationQueue cancelAllOperations];
}

- (void)netRequestData:(NSString *)url
             withParam:(NSDictionary *)para
        withMethodType:(NetworkMethod)method
               success:(SuccessBlock)success
                  fail:(FailBlock)fail
{
    DebugLog(@"\n===========request===========\n%@:\n%@", url, para);
    //    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //manager = [manager initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.0;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"application/x-json",@"text/html", nil];
    if (method == Get) {
        [manager GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            DebugLog(@"\n===========response===========\n%@:\n%@", url, responseObject);
            if (success) {
                success(responseObject);
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            DebugLog(@"\n===========response error===========\n%@:\n%@", url, error.localizedDescription);
            fail(error);
        }];
    }
    else if (method == Post) {
        [manager POST:url parameters:para success:^(NSURLSessionDataTask *task, id responseObject) {
            DebugLog(@"\n===========response===========\n%@:\n%@", url, responseObject);
            if (success) {
                success(responseObject);
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            DebugLog(@"\n===========response error===========\n%@:\n%@", url, error.localizedDescription);
            fail(error);
        }];
    }
}

#pragma mark - 下载文件
- (void)downloadFile:(NSString *)path
             success:(SuccessBlock)success
                fail:(FailBlock)fail {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *URL = [NSURL URLWithString:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        self.downloadProgress = downloadProgress.fractionCompleted;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"downloadProgress" object:nil];
        NSLog(@"cft-progress %.2f",self.downloadProgress);
        
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            fail(error);
        }
        if (filePath) {
            success(filePath.path);
        }
    }];
    _downloadTask = downloadTask;
    [downloadTask resume];
}

- (void)cancelDownload{
    [_downloadTask cancel];
    [_manager.operationQueue cancelAllOperations];
}

//上传图片
- (void)uploadImage:(UIImage *)image
           WithPath:(NSString *)path
            success:(SuccessBlock)success
               fail:(FailBlock)fail

{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //上传图片/文字，只能同POST
    [manager POST:path parameters:nil constructingBodyWithBlock:^(id  _Nonnull formData) {
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        if (data.length / 1024 > 1000) {//不能超过1MB
            data = UIImageJPEGRepresentation(image, 1024*1000.0/(float)data.length);
        }
        //第一个代表文件转换后data数据，第二个代表图片的名字，第三个代表图片放入文件夹的名字，第四个代表文件的类型
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        //        NSString *fileName = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = @"aonicardv";
        [formData appendPartWithFileData:data name:fileName fileName:@"image.jpg" mimeType:@"image/jpg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"uploadProgress = %.2f",uploadProgress.fractionCompleted);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"str---%@",str);
        NSError *myError;
        
        id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&myError];
        success(json);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(error);
    }];
}


//上传视频
- (void)uploadVideo:(NSString *)videoPath
           WithPath:(NSString *)path
            success:(SuccessBlock)success
               fail:(FailBlock)fail
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //上传图片/文字，只能同POST
    [manager POST:path parameters:nil constructingBodyWithBlock:^(id  _Nonnull formData) {
        NSURL *url = [NSURL fileURLWithPath:videoPath];
        NSData *data = [NSData dataWithContentsOfURL:url];
        if (data.length / 1024 > 3000) {//不能超过3MB
            
        }
        //第一个代表文件转换后data数据，第二个代表图片的名字，第三个代表图片放入文件夹的名字，第四个代表文件的类型
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        //        NSString *fileName = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = @"aonicardv";
        [formData appendPartWithFileData:data name:fileName fileName:@"video.mp4" mimeType:@"video/mp4"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"uploadProgress = %.2f",uploadProgress.fractionCompleted);
        self.uploadProgress = uploadProgress.fractionCompleted;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"uploadProgress" object:nil];
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *myError;
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"str:%@",str);
        id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&myError];
        success(json);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(error);
    }];
    
}


//上传文件
- (void)uploadFile:(NSString *)filePath
           WithPath:(NSString *)path
            success:(SuccessBlock)success
               fail:(FailBlock)fail
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //上传图片/文字，只能同POST
   NSURLSessionDataTask *uploadTask = [manager POST:path parameters:nil constructingBodyWithBlock:^(id  _Nonnull formData) {
        NSURL *url = [NSURL fileURLWithPath:filePath];
        NSData *data = [NSData dataWithContentsOfURL:url];
       
       NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
       [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
       [formatter setLocale:[NSLocale currentLocale]];
        NSString *fileName = [formatter stringFromDate:[NSDate date]];
        [formData appendPartWithFileData:data name:fileName fileName:@"firmware.zip" mimeType:@"application/zip"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"uploadProgress = %.2f",uploadProgress.fractionCompleted);
        self.uploadProgress = uploadProgress.fractionCompleted;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"uploadProgress" object:nil];
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *myError;
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"str:%@",str);
        id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&myError];
        success(json);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(error);
    }];
    _uploadTask = uploadTask;
    
}

- (void)cancelUploadFile{
    NSLog(@"cft-cancelUploadFile %s %s",__func__,__TIMESTAMP__);
    [_uploadTask cancel];
}


@end
