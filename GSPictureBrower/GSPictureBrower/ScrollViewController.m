//
//  ViewController.m
//  GSAdsScrollview
//
//  Created by zhangtao on 16/6/21.
//  Copyright © 2016年 BetaTown. All rights reserved.
//

#import "ScrollViewController.h"
#import "GSPictureBrower.h"

@interface ScrollViewController ()<GSPictureBrowerDelegate>

@end

@implementation ScrollViewController

-(id)init{

    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    self.automaticallyAdjustsScrollViewInsets = NO;
   
    CGFloat width = self.view.frame.size.width;
    
    
    GSPictureBrower *scrollView = [[GSPictureBrower alloc]initWithFrame:CGRectMake(0,0,width, CGRectGetHeight(self.view.frame)) andImageDataArray:_imageDataArray andCurrentIndex:_currentIndex];
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];



}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}
-(void)GSPictureBrowerClickAtIndex:(NSInteger)index{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setCookieWithDic{


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
