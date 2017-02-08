//
//  ViewController.m
//  php_ios
//
//  Created by aoni on 17/2/5.
//  Copyright © 2017年 aoni. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)registerEvent:(id)sender {
    [self getResult];
}

/**
 GET请求
 */
- (void)getResult{
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://localhost/phpTest/aviTest.php?name=%@&password=%@",_nameTF.text,_passwordTF.text]];
    
    NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
//        NSLog(@"result = %@",result);3
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


/**
 POST请求
 */
- (void)getResult1{
    NSURL *url = [NSURL URLWithString:@"http://localhost/phpTest/sssss.php"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod = @"POST";
    request.HTTPBody = [[NSString stringWithFormat:@"name=%@&password=%@",_nameTF.text,_passwordTF.text] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@", result);
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error:nil];
        NSLog(@"result:%@",dic[@"result"]);
        
    }];
    
    [task resume];
}

@end
