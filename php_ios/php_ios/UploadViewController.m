//
//  UploadViewController.m
//  php_ios
//
//  Created by mac on 2017/12/8.
//  Copyright © 2017年 aoni. All rights reserved.
//

#import "UploadViewController.h"
#import "FTNetAPIClient.h"
#import "constant.h"

@interface UploadViewController ()

@end

@implementation UploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"上传";
}
- (IBAction)upload:(id)sender {
    [self uploadVideo];
}


- (IBAction)download:(id)sender {
    NSString *file = [NSString stringWithFormat:@"%@/phpTest/videos/1.mp4",kIPHeader];
    [[FTNetAPIClient sharedInstance] downloadFile:file success:^(id responsObject) {
        NSLog(@"cft-response:%@",responsObject);
    } fail:^(NSError *error) {
        NSLog(@"cft-error:%@",error.localizedDescription);
    }];
}



- (void)uploadVideo{
    NSString *file = [[NSBundle mainBundle] pathForResource:@"polyLine" ofType:@"zip"];
    NSString *path = [NSString stringWithFormat:@"%@/phpTest",kIPHeader];
    [[FTNetAPIClient sharedInstance] uploadVideo:file WithPath:path success:^(id responsObject) {
        NSLog(@"cft-response:%@",responsObject);
    } fail:^(NSError *error) {
        NSLog(@"cft-error:%@",error.localizedDescription);
    }];
}


@end
