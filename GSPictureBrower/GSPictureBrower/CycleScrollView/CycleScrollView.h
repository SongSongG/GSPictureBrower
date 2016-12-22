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
@protocol CycleScrollViewDelegate <NSObject>

@optional
//点击图片
-(void)CycleScrollViewClickAtIndex:(NSInteger)index;

@end

@interface CycleScrollView : UIView


@property (nonatomic, strong)NSArray *imageDataArray;//数据源
@property (nonatomic, assign)CGFloat timeInterval;//滚动时间间隔,默认3.0s

@property (nonatomic, strong)id<CycleScrollViewDelegate>delegate;


-(id)initWithFrame:(CGRect)frame andScrolledType:(ScrolledType)scrolledType;

@end
