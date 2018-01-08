//
//  VideoController.m
//  php_ios
//
//  Created by mac on 2017/12/7.
//  Copyright © 2017年 aoni. All rights reserved.
//

#import "VideoController.h"
//#import "PlayerViewController.h"
#import "FTWebViewController.h"
#import "constant.h"



@interface VideoController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataList;
@property (nonatomic, strong) UITableView  *tableView;

@end

@implementation VideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"视频列表";
    [self getVidesNames];
    [self addTableView];
}


- (void)addTableView{
    if (!_tableView) {
        CGRect frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64);
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60;
        _tableView.separatorStyle = UITableViewCellSelectionStyleBlue;
        _tableView.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:_tableView];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = _dataList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    PlayerViewController *vc = [[PlayerViewController alloc] init];
//    vc.videoName = _dataList[indexPath.row];
//    [self.navigationController pushViewController:vc animated:YES];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/phpTest/videos/%@",kIPHeader,_dataList[indexPath.row]];
    
    //NSString *encodeUrl = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *encodeUrl = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSLog(@"cft-url:%@ encoderUrl:%@",urlStr,encodeUrl);
    FTWebViewController *webVC = [[FTWebViewController alloc] init];
    [webVC loadWebURLSring:encodeUrl];
    [self.navigationController pushViewController:webVC animated:YES];
}



- (void)getVidesNames{
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *urlStr = [NSString stringWithFormat:@"%@/phpTest/files.php",kIPHeader];
    NSString *str = [urlStr stringByRemovingPercentEncoding];
    NSURL *url = [NSURL URLWithString:str];
    NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data != nil) {
            NSArray *videos = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
            NSLog(@"videos = %@",videos);
            _dataList = [NSArray arrayWithArray:videos];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }];
    [task resume];
}




@end
