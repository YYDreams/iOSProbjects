
//
//  CtrlEncapViewController.m
//  iOSProjects
//
//  Created by flowerflower on 2018/8/20.
//  Copyright © 2018年 flowerflower. All rights reserved.
//

#import "CtrlEncapViewController.h"
#import "HHLotteryListCell.h"
#import "HHLotteryListModel.h"
#import "HHDBManager.h"
#import "HHBannerModel.h"
#import "HHDorpDownController.h"
#import "HHCapitalViewController.h"
@interface CtrlEncapViewController ()

/** <#注释#> */
@property (nonatomic, strong) NSArray *dataArr;
@end
static NSString *const HHLotteryListCellID = @"HHLotteryListCell";

@implementation CtrlEncapViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    [self setupTableView];
    
    [self setupRefresh];
    
}
#pragma mark - setupNav

- (void)setupNav{
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"navigationbar_back" highImage:@"navigationbar_back" target:self action:@selector(navRightOnClick)];
    
    
}
- (void)navRightOnClick{
    
    
    [self.navigationController pushViewController:[HHCapitalViewController new] animated:YES];
}

#pragma mark - setupTableView
- (void)setupTableView{
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HHLotteryListCell" bundle:nil] forCellReuseIdentifier:HHLotteryListCellID];
    self.tableView.estimatedRowHeight = 60;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)setupRefresh{
    
    [self loadCacheData];
    
    
    [self setupRefreshTarget:nil];
    
    [self loadListDatilWithPageNo:1 andStatus:3];
    
}

- (void)loadCacheData{

    HHDBManager *manager = [[HHDBManager alloc]initWithobjectClass:[HHLotteryListModel class]];
    NSArray *cacheData = [manager getAllObjects];
    if (cacheData > 0 ) {
        self.dataArr = cacheData;
        [self.tableView reloadData];

    }
}

- (void)saveLotteryCache:(NSArray *)lotterys{
    
    HHDBManager *manager = [[HHDBManager alloc]initWithobjectClass:[HHLotteryListModel class]];
    
    [manager insertObjects:lotterys];

}

#pragma mark - loadDataFromNetwork
- (void)loadListDatilWithPageNo:(int)pageNo andStatus:(int)status{
    
    WeakSelf;
    NSString *page_size = @"20";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @(pageNo);
    param[@"page_size"] = page_size?:@"";
    
    //@"v2/block/home/app/banner"
    [HTTPRequest GET:kLotteryUrl parameter:param success:^(id resposeObject) {  //
        
        if ([resposeObject[@"data"] isKindOfClass:[NSArray class]] && ![resposeObject[@"data"] isEqual:[NSNull class]]) {

            NSArray *dataArr = [HHLotteryListModel objectsInArray:resposeObject[@"data"]];
//            [self.dataArr addObjectsFromArray:dataArr];
            self.dataArr = dataArr;
//            int totalPage = [resposeObject[@"data"][@"pages"] intValue];
//
            [weakSelf successEndRefreshStatus:status totalPage:(int)dataArr.count];

            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (self.dataArr.count >0 && self.dataArr.count<20) {
                    
                    [weakSelf endRefreshWithNoMoreData];
                }
                if (dataArr.count >0) {
                    [weakSelf.tableView reloadData];
                    
                    [weakSelf saveLotteryCache:dataArr];
                }
                
                
                
            });
            
        }else{
            [MBProgressHUD LY_ShowError:resposeObject[@"msg"] time:2];
            [weakSelf failEndRefreshStatus:status];
            
        }
        self.currentPageStatus = PageStatusSucceed;
    } failure:^(NSError *error) {
        [weakSelf failEndRefreshStatus:status];
        [MBProgressHUD LY_ShowError:kNoNetworkTips time:2.0];
        self.currentPageStatus = PageStatusError;
        self.emptyViewTapBlock = ^{
            [weakSelf pullDownRefresh:1];
        };
    }];
    
}
- (void)pullDownRefresh:(int)page{
    
//    [self.dataArr  removeAllObjects];
    //0 结束头部
    [self loadListDatilWithPageNo:page andStatus:0];
    
}
- (void)pullUpRefresh:(int)page lastPage:(BOOL)isLastPage{
    
    if (isLastPage) {
        return;
    }
    [self loadListDatilWithPageNo:page andStatus:1];
    
}

#pragma mark - <UITableViewDataSource,UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HHLotteryListCell *cell = [tableView dequeueReusableCellWithIdentifier:HHLotteryListCellID forIndexPath:indexPath];
    
    
    cell.model = [self.dataArr safeObjectAtIndex:indexPath.row];
    
    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [self.navigationController pushViewController:[HHDorpDownController new] animated:YES];
    
}
#pragma mark - Setter && Getter Methods
//- (NSMutableArray *)dataArr{
//    if (!_dataArr) {
//        _dataArr = [NSMutableArray array];
//   }
//    return _dataArr;
//}




@end
