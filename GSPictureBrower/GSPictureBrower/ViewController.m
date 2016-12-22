//
//  ViewController.m
//  GSPictureBrower
//
//  Created by zhangtao on 16/12/22.
//  Copyright © 2016年 gaosongsong. All rights reserved.
//

#import "ViewController.h"
#import "CycleScrollView.h"
#import "ScrollViewController.h"

@interface ViewController ()<CycleScrollViewDelegate>


@property (nonatomic, strong)NSArray *array;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _array = @[@"http://img.hean.fantayun.cn/hean/advertisement/k/v/w/1466152466394285.jpg",@"http://img.hean.fantayun.cn/hean/advertisement/0/i/d/1466152476910327.jpg",@"http://img.hean.fantayun.cn/hean/advertisement/d/0/l/146615248432110.jpg"];
    CGFloat height = (self.view.bounds.size.height-64)/3.0;
    CGFloat width = self.view.frame.size.width;
    
    CycleScrollView *scrollView1 = [[CycleScrollView alloc]initWithFrame:CGRectMake(0, 64,width, height) andScrolledType:ScrolledTypeCycle];
    scrollView1.delegate = self;
    scrollView1.imageDataArray = _array;
    scrollView1.timeInterval = 1;
    [self.view addSubview:scrollView1];
 
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)CycleScrollViewClickAtIndex:(NSInteger)index{

    ScrollViewController *controller = [[ScrollViewController alloc]init];
    controller.imageDataArray = _array;
    controller.currentIndex = index;
    
    [self presentViewController:controller animated:YES completion:nil];
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
