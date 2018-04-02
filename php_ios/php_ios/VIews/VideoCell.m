//
//  VideoCell.m
//  php_ios
//
//  Created by mac on 2018/4/1.
//  Copyright © 2018年 aoni. All rights reserved.
//

#import "VideoCell.h"
#import "Masonry.h"
#import "TYDownLoadDataManager.h"

@interface VideoCell()

@property(nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UIProgressView  *progress;

@property (nonatomic, strong) TYDownloadModel  *downloadModel;

@end

@implementation VideoCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID=@"settingCell";
    VideoCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell=[[VideoCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    return  cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.btn];
        [self.contentView addSubview:self.progress];
        [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-10);
            make.centerY.equalTo(self.contentView);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(36);
        }];
        [self.progress mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.right.equalTo(self.contentView).offset(-20);
            make.top.equalTo(self.contentView).offset(4);
        }];
        
    }
    return  self;
}

- (void)setModel:(VideoModel *)model{
    _downloadModel = [[TYDownLoadDataManager manager] downLoadingModelForURLString:model.videoUrl];
    if (!_downloadModel) {
        _downloadModel = [[TYDownloadModel alloc]initWithURLString:model.videoUrl];
    }
    TYDownloadProgress *progress = [[TYDownLoadDataManager manager]progessWithDownloadModel:_downloadModel];
    self.progress.progress = progress.progress;
    if (progress.progress == 1.0 || progress.progress==0.0) {
        self.progress.hidden = YES;
    }else{
        self.progress.hidden = NO;
    }
    
    [self.btn setTitle:[[TYDownLoadDataManager manager] isDownloadCompletedWithDownloadModel:_downloadModel] ? @"已下载":@"开始" forState:UIControlStateNormal];
    
}

- (void)downloadAction:(UIButton *)btn{
    TYDownLoadDataManager *manager = [TYDownLoadDataManager manager];
    if (_downloadModel.state == TYDownloadStateReadying) {
        [manager cancleWithDownloadModel:_downloadModel];
        return;
    }
    
    if ([manager isDownloadCompletedWithDownloadModel:_downloadModel]) {
        [manager deleteFileWithDownloadModel:_downloadModel];
    }
    
    if (_downloadModel.state == TYDownloadStateRunning) {
        [manager suspendWithDownloadModel:_downloadModel];
        return;
    }
    [self startDownlaod];
}

- (void)startDownlaod
{
    TYDownLoadDataManager *manager = [TYDownLoadDataManager manager];
    __weak typeof(self) weakSelf = self;
    [manager startWithDownloadModel:_downloadModel progress:^(TYDownloadProgress *progress) {
        NSLog(@"cft-progress:%.2f",progress.progress);
        weakSelf.progress.hidden = NO;
        weakSelf.progress.progress = progress.progress;
        
    } state:^(TYDownloadState state, NSString *filePath, NSError *error) {
        if (state == TYDownloadStateCompleted) {
            weakSelf.progress.progress = 1.0;
            weakSelf.progress.hidden = YES;
            [weakSelf.btn setTitle:@"已下载" forState:UIControlStateNormal];
        }
        NSLog(@"state %ld error%@ filePath%@",state,error,filePath);
    }];
}

- (UIProgressView *)progress{
    if (!_progress) {
        _progress = [[UIProgressView alloc] init];
        _progress.progress = 0.0;
    }
    return _progress;
}

- (UIButton *)btn{
    if (!_btn) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn setTitle:@"download" forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        _btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        _btn.layer.cornerRadius = 5.0;
        _btn.layer.borderWidth = 1.0;
        _btn.layer.borderColor = [UIColor orangeColor].CGColor;
        [_btn addTarget:self action:@selector(downloadAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn;
}




@end
