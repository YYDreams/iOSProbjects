//
//  SSCCellContentView1.m
//  iOSProjects
//
//  Created by funtSui on 2018/12/5.
//  Copyright © 2018年 flowerflower. All rights reserved.
//

#import "SSCCellContentView1.h"

@implementation SSCCellContentView1


- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setupSubView];
        
    }
    return self;
    
}
- (void)setupSubView{
    
}

+ (CGFloat)getHeight :(SSCBallCellModel *)model{
    
 
    return 50;
}

@end