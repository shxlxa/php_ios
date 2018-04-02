//
//  LocalVideoController.m
//  php_ios
//
//  Created by mac on 2018/4/1.
//  Copyright © 2018年 aoni. All rights reserved.
//

#import "LocalVideoController.h"
#import "Tools.h"
#import <MediaPlayer/MediaPlayer.h>
#import "constant.h"

@interface LocalVideoController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray  *dataList;

@property (nonatomic,strong) MPMoviePlayerViewController *moviePlayerViewController;


@end

@implementation LocalVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *arr = [Tools getBundleVideoNum];
    _dataList = arr;
    [self addTableView];
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
    
    NSString *fileName = _dataList[indexPath.row];
    NSString *dir = [kDocumentsDirectory stringByAppendingPathComponent:@"TYDownloadCache"];
    NSString *filepath = [dir stringByAppendingPathComponent:fileName];
    _moviePlayerViewController=[[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL fileURLWithPath:filepath]];
    [self presentMoviePlayerViewControllerAnimated:_moviePlayerViewController];
}


- (void)addTableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60;
        _tableView.separatorStyle = UITableViewCellSelectionStyleBlue;
        [self.view addSubview:_tableView];
    }
}



@end
