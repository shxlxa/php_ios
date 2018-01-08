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
    [self getVideoNames];
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
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/phpTest/videos/%@",kIPHeader,_dataList[indexPath.row]];
    NSString *encodeUrl = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSLog(@"cft-url:%@ encoderUrl:%@",urlStr,encodeUrl);
    FTWebViewController *webVC = [[FTWebViewController alloc] init];
    [webVC loadWebURLSring:encodeUrl];
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)getVideoNames{
    NSString *urlStr = [NSString stringWithFormat:@"%@/phpTest/files.php",kIPHeader];
    NSString *str = [urlStr stringByRemovingPercentEncoding];
    [[FTNetAPIClient sharedInstance] getRequestDataWithUrl:str param:nil success:^(id responsObject) {
        NSLog(@"cft-res %@",responsObject);
        NSArray *videos = responsObject;
        _dataList = [NSArray arrayWithArray:videos];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } fail:^(NSError *error) {
        NSLog(@"cft-fail %@",error.localizedDescription);
    }];
}


@end
