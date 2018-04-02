//
//  RegisterViewController.m
//  php_ios
//
//  Created by mac on 2018/1/18.
//  Copyright © 2018年 aoni. All rights reserved.
//

#import "RegisterViewController.h"
#import "constant.h"
#import "FTNetAPIClient.h"


@interface RegisterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)registerEvent:(id)sender {
    //[self modifyInfo];
    
    [self writeDiary];
}

- (void)getDiaryList{
    NSString *url = [NSString stringWithFormat:@"%@/article_list.php?name=lyl",kIPHeader];
    NSString *urlStringUTF8 = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [[FTNetAPIClient sharedInstance] getRequestDataWithUrl:urlStringUTF8 success:^(id responsObject) {
        NSLog(@"cft-responsible %@",responsObject);
    } fail:^(NSError *error) {
        NSLog(@"cft-error %@",error.localizedDescription);
    }];
}

- (void)writeDiary{
    NSString *url = [NSString stringWithFormat:@"%@/article.php?name=lyl&title=%@&content=%@",kIPHeader,_nameTF.text,_passwordTF.text];
    NSString *urlStringUTF8 = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [[FTNetAPIClient sharedInstance] getRequestDataWithUrl:urlStringUTF8 success:^(id responsObject) {
        NSLog(@"cft-responsible %@",responsObject);
    } fail:^(NSError *error) {
        NSLog(@"cft-error %@",error.localizedDescription);
    }];
}

- (void)modifyInfo{
    NSString *url = [NSString stringWithFormat:@"%@/modify.php?id=105&name=%@&sign=%@",kIPHeader,_nameTF.text,_passwordTF.text];
    NSString *urlStringUTF8 = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [[FTNetAPIClient sharedInstance] getRequestDataWithUrl:urlStringUTF8 success:^(id responsObject) {
        NSLog(@"cft-responsible %@",responsObject);
    } fail:^(NSError *error) {
        NSLog(@"cft-error %@",error.localizedDescription);
    }];
}

- (void)getUserInfo{
     NSString *url = [NSString stringWithFormat:@"%@/userInfo.php?name=%@",kIPHeader,_nameTF.text];
        [[FTNetAPIClient sharedInstance] getRequestDataWithUrl:url success:^(id responsObject) {
            NSLog(@"cft-responsible %@",responsObject);
        } fail:^(NSError *error) {
            NSLog(@"cft-error %@",error.localizedDescription);
        }];
}





/**
 GET请求
 */
- (void)addRegister{
//    NSString *urlStr = [NSString stringWithFormat:@"%@/phpTest/aviTest.php?name=%@&password=%@",kIPHeader,_nameTF.text,_passwordTF.text];
//    NSLog(@"cft-urlStr:%@",urlStr);
//    [[FTNetAPIClient sharedInstance] getRequestDataWithUrl:urlStr param:nil success:^(id responsObject) {
//        NSLog(@"cft-responsible %@",responsObject);
//    } fail:^(NSError *error) {
//        NSLog(@"cft-error %@",error.localizedDescription);
//    }];
    
    
        NSURLSession *session = [NSURLSession sharedSession];
        //NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/phpTest/aviTest.php?name=%@&password=%@",kIP,_nameTF.text,_passwordTF.text]];
        NSString *urlStr = [NSString stringWithFormat:@"%@/aviTest.php?name=%@&password=%@",kIPHeader,_nameTF.text,_passwordTF.text];
        NSString *str = [urlStr stringByRemovingPercentEncoding];
        NSURL *url = [NSURL URLWithString:str];
        NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
            NSLog(@"result = %@",result);
            if (data != nil) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
                NSLog(@"dic = %@",dic);
                NSString *res = dic[@"result"];
                if ([res isEqualToString:@"success"]) {
                    NSLog(@"注册成功");
                } else{
                    NSLog(@"%@",res);
                }
            }
        }];
        [task resume];
}




@end
