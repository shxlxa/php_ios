//
//  MainViewController.m
//  php_ios
//
//  Created by mac on 2018/1/4.
//  Copyright © 2018年 aoni. All rights reserved.
//

#import "MainViewController.h"
#import "VideoController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
