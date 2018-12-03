//
//  SSCStructChildView.h
//  iOSProjects
//
//  Created by funtSui on 2018/11/28.
//  Copyright © 2018年 flowerflower. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSCStructModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SSCStructChildView : UIView


@property (nonatomic,readonly)SSCChildModel *childModel;//选中的玩法细则


@property(nonatomic,strong)NSArray<SSCChildModel *> *dataArr;

@property (nonatomic,strong)NSString *lotteryId;//彩种id


@property(nonatomic,copy)void(^handlerChildSelectCallBack)(SSCChildModel *model);


@end


NS_ASSUME_NONNULL_END


@interface SSCPlaySonButton : UIButton


@property (nonatomic,strong)SSCChildModel *model;

@end