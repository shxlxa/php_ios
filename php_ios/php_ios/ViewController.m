//
//  ViewController.m
//  php_ios
//
//  Created by aoni on 17/2/5.
//  Copyright © 2017年 aoni. All rights reserved.
//

#import "ViewController.h"
#import "constant.h"
#import "FTNetAPIClient.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)registerEvent:(id)sender {
//    [self getResult];
    
//    [self getVidesNames];
    
    [self getUserInfo];
}

- (void)getUserInfo{
   // NSString *url = [NSString stringWithFormat:@"%@/phpTest/userInfo.php?name=%@",kIPHeader,_nameTF.text];
//    [[FTNetAPIClient sharedInstance] getRequestDataWithUrl:url param:nil success:^(id responsObject) {
//        NSLog(@"cft-responsible %@",responsObject);
//    } fail:^(NSError *error) {
//        NSLog(@"cft-error %@",error.localizedDescription);
//    }];
    
    NSURLSession *session = [NSURLSession sharedSession];
    //NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/phpTest/aviTest.php?name=%@&password=%@",kIP,_nameTF.text,_passwordTF.text]];
    NSString *urlStr = [NSString stringWithFormat:@"%@/phpTest/userInfo.php?name=%@",kIPHeader,_nameTF.text];
    NSString *str = [urlStr stringByRemovingPercentEncoding];
    NSURL *url = [NSURL URLWithString:str];
    NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data != nil) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
            NSLog(@"dic = %@",dic);
            NSString *res = dic[@"result"];
            if ([res isEqualToString:@"success"]) {
                NSLog(@"获取成功");
            } else{
                NSLog(@"%@",res);
            }
        }
    }];
    [task resume];
}

- (void)getVidesNames{
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *urlStr = [NSString stringWithFormat:@"%@/phpTest/files.php",kIPHeader];
    NSString *str = [urlStr stringByRemovingPercentEncoding];
    NSURL *url = [NSURL URLWithString:str];
    NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSLog(@"result = %@",result);
        if (data != nil) {
            NSArray *videos = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
            NSLog(@"videos = %@",videos);
        }
    }];
    [task resume];
}

/**
 GET请求
 */
- (void)getResult{
    NSString *urlStr = [NSString stringWithFormat:@"%@/phpTest/aviTest.php?name=%@&password=%@",kIPHeader,_nameTF.text,_passwordTF.text];
    [[FTNetAPIClient sharedInstance] getRequestDataWithUrl:urlStr param:nil success:^(id responsObject) {
        NSLog(@"cft-responsible %@",responsObject);
    } fail:^(NSError *error) {
        NSLog(@"cft-error %@",error.localizedDescription);
    }];
    
    
//    NSURLSession *session = [NSURLSession sharedSession];
//    //NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/phpTest/aviTest.php?name=%@&password=%@",kIP,_nameTF.text,_passwordTF.text]];
//    NSString *urlStr = [NSString stringWithFormat:@"%@/phpTest/aviTest.php?name=%@&password=%@",kIPHeader,_nameTF.text,_passwordTF.text];
//    NSString *str = [urlStr stringByRemovingPercentEncoding];
//    NSURL *url = [NSURL URLWithString:str];
//    NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//
//        NSLog(@"result = %@",result);
//        if (data != nil) {
//            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
//            NSLog(@"dic = %@",dic);
//            NSString *res = dic[@"result"];
//            if ([res isEqualToString:@"success"]) {
//                NSLog(@"注册成功");
//            } else{
//                NSLog(@"%@",res);
//            }
//        }
//    }];
//    [task resume];
}




@end
