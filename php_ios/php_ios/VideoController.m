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
#import "VideoCell.h"
#import "VideoModel.h"


@interface VideoController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) UITableView  *tableView;

@end

@implementation VideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataList = [NSMutableArray array];
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
    VideoCell *cell = [VideoCell cellWithTableView:tableView];
    VideoModel *model = _dataList[indexPath.row];
    cell.model = model;
    cell.textLabel.text = model.videoName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    VideoModel *model = _dataList[indexPath.row];
    NSString *encodeUrl = [model.videoUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSLog(@"cft-url:%@",model.videoUrl);
    FTWebViewController *webVC = [[FTWebViewController alloc] init];
    [webVC loadWebURLSring:encodeUrl];
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)getVideoNames{
    NSString *urlStr = [NSString stringWithFormat:@"%@/phpTest/files.php?dir=%@",kIP,self.folder];
    NSString *str = [urlStr stringByRemovingPercentEncoding];
    [[FTNetAPIClient sharedInstance] getRequestDataWithUrl:str success:^(id responsObject) {
        NSLog(@"cft-res %@",responsObject);
        NSArray *videos = responsObject;
        for (NSString *video in videos) {
            VideoModel *model = [[VideoModel alloc] init];
            model.videoName = video;
            model.videoUrl = [NSString stringWithFormat:@"%@/phpTest/%@/%@",kIP,self.folder,video];
            [_dataList addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } fail:^(NSError *error) {
        NSLog(@"cft-fail %@",error.localizedDescription);
    }];
}


@end
