//
//  CycleScrollView.h
//  GSAdsScrollview
//
//  Created by zhangtao on 16/6/21.
//  Copyright © 2016年 BetaTown. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ScrolledType) {

    ScrolledTypeNO,//不滚动
    ScrolledTypeBack,//滚动到最后的索引，在倒着回来
    ScrolledTypeCycle//循环滚动
};
@protocol GSPictureBrowerDelegate <NSObject>

@optional
//点击图片
-(void)GSPictureBrowerClickAtIndex:(NSInteger)index;

@end

@interface GSPictureBrower : UIView


@property (nonatomic, strong)NSArray *imageDataArray;//数据源
@property (nonatomic, assign)NSInteger currentIndex;
@property (nonatomic, strong)id<GSPictureBrowerDelegate>delegate;


-(id)initWithFrame:(CGRect)frame andImageDataArray:(NSArray *)imageDataArray andCurrentIndex:(NSInteger)currentIndex;

@end
