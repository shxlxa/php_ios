//
//  MainViewController.m
//  php_ios
//
//  Created by mac on 2018/1/4.
//  Copyright © 2018年 aoni. All rights reserved.
//

#import "MainViewController.h"
#import "VideoController.h"
#import "FTWebViewController.h"
#import "constant.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"cft-ip %@",kIP);
}
- (IBAction)videoList:(id)sender {
    VideoController *vc = [[VideoController alloc] init];
    vc.folder = @"videos";
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)python:(id)sender {
    VideoController *vc = [[VideoController alloc] init];
    vc.folder = @"python";
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)korean:(id)sender {
    VideoController *vc = [[VideoController alloc] init];
    vc.folder = @"korean";
    [self.navigationController pushViewController:vc animated:YES];
}

// http://192.168.1.101/phpTest/images/default.png
- (IBAction)image:(id)sender {
    NSString *urlStr = [NSString stringWithFormat:@"%@/phpTest/images/default.png",kIPHeader];
    NSString *encodeUrl = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSLog(@"cft-url:%@",urlStr);
    FTWebViewController *webVC = [[FTWebViewController alloc] init];
    [webVC loadWebURLSring:encodeUrl];
    [self.navigationController pushViewController:webVC animated:YES];
}


@end
