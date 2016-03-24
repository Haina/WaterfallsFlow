//
//  ViewController.m
//  WaterFall
//
//  Created by Hanna on 16/3/23.
//  Copyright © 2016年 Hanna. All rights reserved.
//

#import "ViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "WNImageContentTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "UIImageView+AFNetworking.h"

#define kReqeustNum 4 //每次增加四个

static NSString *const imageCellIdentifier = @"imageContentCell";

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_totalArray;
}
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *imageHeights;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.tableView registerNib:[UINib nibWithNibName:@"WNImageContentTableViewCell" bundle:nil]
         forCellReuseIdentifier:imageCellIdentifier];
    
    //    UIView *view =[ [UIView alloc]init];
    //    view.backgroundColor = [UIColor clearColor];
    //    [_tableView setTableFooterView:view];
    //    [_tableView setTableHeaderView:view];
    
    _dataArray = [NSMutableArray array];
    _totalArray = @[@"https://dn-dev-weneber.qbox.me/7a26fd2c-e440-4ad7-81d5-8cbcd7b3538e.png",
                    @"http://f1.topitme.com/1/83/18/115852641215d18831o.jpg",
                    @"http://f5.topitme.com/5/ce/be/1153885652ec4bece5o.jpg",
                    @"http://f7.topitme.com/7/1f/74/1153275443162741f7o.jpg",
                    @"http://f6.topitme.com/6/ba/19/115381388627319ba6o.jpg",
                    @"http://f8.topitme.com/8/40/6b/115345256304e6b408o.jpg",
                    @"http://f6.topitme.com/6/e7/31/1153452563e7d31e76o.jpg",
                    @"http://fa.topitme.com/a/44/f7/1153948325901f744ao.jpg",
                    @"http://f1.topitme.com/1/8e/96/11539797772f4968e1o.jpg",
                    @"http://f0.topitme.com/0/04/67/115852641744d67040l.jpg",
                    @"http://f1.topitme.com/1/31/07/1158549681e4507311o.jpg",
                    @"http://ff.topitme.com/f/a0/bc/1149710069185bca0fo.jpg",
                    @"http://f10.topitme.com/l/201008/11/12815381933985.jpg",
                    @"http://f10.topitme.com/l/201005/21/12743805639278.jpg",
                    @"http://f10.topitme.com/l/201010/09/12866350091530.jpg",
                    @"http://f8.topitme.com/8/3f/e7/11305132265a5e73f8l.jpg",
                    @"http://i10.topitme.com/o159/101595408064499889.jpg",
                    @"http://fb.topitme.com/b/1b/22/112729331125c221bbo.jpg",
                    @"http://f4.topitme.com/4/d9/05/11272933075e505d94o.jpg",
                    @"http://i10.topitme.com/l163/1016314935ee7bfade.jpg",
                    @"http://i10.topitme.com/l169/1016937296c8d8316c.jpg",
                    @"http://f1.topitme.com/1/1b/ca/1127498913e5aca1b1l.jpg",
                    @"http://f1.topitme.com/1/f1/ff/1127914425713fff11l.jpg",
                    @"http://f5.topitme.com/5/bb/9e/112593232912e9ebb5l.jpg",
                    @"http://i10.topitme.com/l167/10167588642a8aedbb.jpg",
                    @"http://fc.topitme.com/c/32/0d/11277777835bc0d32cl.jpg"];
    
    __weak __typeof(self)weakSelf = self;
    
    _dataArray = [NSMutableArray arrayWithArray:_totalArray];
    _imageHeights = [NSMutableArray array];
    [self setDefaultRowHeights];
    [self.tableView reloadData];
    
    //底部刷新
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        __strong __typeof(self)strongSelf = weakSelf;
        if (strongSelf) {
            //            sleep(1.5);
            NSInteger count = 0;
            for (NSInteger idx = _dataArray.count; idx < _totalArray.count;++idx) {
                ++count;
                if (count <kReqeustNum) {
                    [strongSelf.dataArray addObject:_totalArray[idx]];
                }
            }
        }
        [self setDefaultRowHeights];
        [strongSelf.tableView reloadData];
        
        [strongSelf.tableView.mj_footer endRefreshing];
        
    }];
    
    //顶部刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong __typeof(self)strongSelf = weakSelf;
        if (strongSelf) {
            _dataArray = [NSMutableArray arrayWithArray:@[_totalArray[0]]];
        }

        [self setDefaultRowHeights];
        [strongSelf.tableView reloadData];
        [strongSelf.tableView.mj_header endRefreshing];
    }];
    
}



#pragma mark--
#pragma mark--UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WNImageContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:imageCellIdentifier];
    NSURL *url = [NSURL URLWithString:_dataArray[indexPath.row]];
    
    __weak __typeof(WNImageContentTableViewCell *)weakCell = cell;
    __weak __typeof(self)weakSelf = self;
    
    
    [cell.imageContent sd_setImageWithURL:url placeholderImage:[UIImage new] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        weakCell.imageContent.image = image;
        // Update table row heights
        NSInteger oldHeight = [weakSelf.imageHeights[indexPath.row] integerValue];
        NSInteger newHeight = (int)image.size.height;
        
        // Fix if image is wider than the imageview's frame
        CGFloat ratio = image.size.height / image.size.width;
        CGFloat width = [[UIScreen mainScreen] bounds].size.width-20;
        newHeight = width * ratio;
        
        // Update table row height if image is in different size
        if (oldHeight != newHeight) {
            weakSelf.imageHeights[indexPath.row] = @(newHeight);
        }
        
        switch (cacheType) {
            case SDImageCacheTypeNone:
                break;
            case SDImageCacheTypeDisk:
            {
                [tableView reloadData];
            }
                break;
            case SDImageCacheTypeMemory:
            default:
                break;
        }
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat rowHeight = [self.imageHeights[indexPath.row] floatValue];
    return rowHeight;
}

#pragma mark - Updating row heights

- (void)setDefaultRowHeights {
    self.imageHeights = [NSMutableArray arrayWithCapacity:_dataArray.count];
    for (NSInteger i = 0; i < _dataArray.count; i++) {
        self.imageHeights[i] = @(self.tableView.rowHeight);
    }
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:imageCellIdentifier];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    //    NSLog(@"row: %ld---screenWidth%f-height: %f %f",indexPath.row,[[UIScreen mainScreen]bounds].size.width-20,height,rowHeight);
    return height;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
