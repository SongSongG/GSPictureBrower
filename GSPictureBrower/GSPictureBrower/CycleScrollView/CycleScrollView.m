//
//  CycleScrollView.m
//  GSAdsScrollview
//
//  Created by zhangtao on 16/6/21.
//  Copyright © 2016年 BetaTown. All rights reserved.
//

#import "CycleScrollView.h"
#import "UIImageView+WebCache.h"


#define TAG_ScrollViewImageView  11111


@interface CycleScrollView ()<UIScrollViewDelegate>

@property (nonatomic, assign)ScrolledType scrolledType;//滚动的类型
@property (nonatomic, assign)NSInteger index;//页码
@property (nonatomic, strong)UIPageControl *pageControl;
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)NSTimer *timer;


@property (nonatomic, assign)BOOL isForward;

@end

@implementation CycleScrollView

@synthesize timeInterval = _timeInterval;

-(void)setTimeInterval:(CGFloat)timeInterval{

    _timeInterval = timeInterval;
    
    if (_scrolledType != ScrolledTypeNO) {

        [self setUpTimer];
        
    }
}
-(CGFloat)timeInterval{

    if (_timeInterval == 0) {
        
        _timeInterval = 5.0;
    }
    return _timeInterval;
}

-(id)initWithFrame:(CGRect)frame andScrolledType:(ScrolledType)scrolledType{
    
    if (self == [super initWithFrame:frame]) {
        
        _scrolledType = scrolledType;
        _isForward = YES;
        
        
    }
    return self;

}
-(UIScrollView *)scrollView{

    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:_scrollView];
        
    }
    return _scrollView;
}
-(UIPageControl *)pageControl{

    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]init];
        _pageControl.center = CGPointMake(self.center.x, self.bounds.size.height-10);
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:191.0/255 green:130.0/255 blue:98.0/255 alpha:1];
        
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        [self addSubview:_pageControl];
    }
    
    return _pageControl;
}
-(void)setImageDataArray:(NSArray *)imageDataArray{
    _imageDataArray = imageDataArray;
    [self initContentView];

}

-(void)initContentView{
    
    for (UIView *subView in [self.scrollView subviews]) {
        
        [subView removeFromSuperview];
    }
    if (self.imageDataArray.count==1) {
        self.pageControl.hidden = YES;
    }else{
        self.pageControl.hidden = NO;
        self.pageControl.numberOfPages = self.imageDataArray.count;
        self.pageControl.currentPage = 0;
    }
   
    if (_scrolledType == ScrolledTypeCycle) {
        
        self.scrollView.contentSize = CGSizeMake(self.bounds.size.width*3, self.bounds.size.height);
        self.scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
        for (int i=0; i<3; i++) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width*i, 0, self.bounds.size.width, self.bounds.size.height)];
            imageView.tag = TAG_ScrollViewImageView+i;
            [self.scrollView addSubview:imageView];
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImageView:)];
            [imageView addGestureRecognizer:tap];
        }
        _index = 0;
        [self changeImages];
        
    }else{
        self.scrollView.contentSize = CGSizeMake(self.bounds.size.width*_imageDataArray.count, self.bounds.size.height);
        for (int i=0; i<_imageDataArray.count; i++) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width*i, 0, self.bounds.size.width, self.bounds.size.height)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageDataArray[i]]];
            [self.scrollView addSubview:imageView];
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImageView:)];
            [imageView addGestureRecognizer:tap];
        }
    }
    
    if (_scrolledType != ScrolledTypeNO) {
        
        [self setUpTimer];
        
    }

}
-(void)setUpTimer{
    
    [_timer invalidate];
    _timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(slideToNext:) userInfo:nil repeats:YES];


}
-(void)slideToNext:(NSTimer *)timer{

    CGPoint scrollViewOffset = _scrollView.contentOffset;
    switch (_scrolledType) {
        case ScrolledTypeCycle:{
        
            scrollViewOffset.x+=self.bounds.size.width;
        }
            break;
        case ScrolledTypeBack:{
            if (_isForward) {
                
                if (self.index < self.imageDataArray.count-1) {
                    
                    self.index++;
                    
                }else{
                    _isForward = NO;
                    self.index--;
                }
                
            }else{
                if (self.index>0) {
                    self.index--;
                }else{
                    
                    _isForward = YES;
                    self.index++;
                }
                
            }
            scrollViewOffset.x = self.index*self.bounds.size.width;
            
        }
        default:
            break;
    }
    [self.scrollView setContentOffset:scrollViewOffset animated:YES];

}
-(void)changeImages{
    
    UIImageView *firstImageView = [_scrollView viewWithTag:TAG_ScrollViewImageView];
    UIImageView *secondImageView = [_scrollView viewWithTag:TAG_ScrollViewImageView+1];
    UIImageView *thirdImageView = [_scrollView viewWithTag:TAG_ScrollViewImageView+2];
    
    if (_index==0) {
        
        [firstImageView sd_setImageWithURL:[NSURL URLWithString:_imageDataArray.lastObject] placeholderImage:nil];
        [secondImageView sd_setImageWithURL:[NSURL URLWithString:_imageDataArray[_index]] placeholderImage:nil];
        if (_imageDataArray.count>1) {
            [thirdImageView sd_setImageWithURL:[NSURL URLWithString:_imageDataArray[_index+1]] placeholderImage:nil];
        }else{
            
            [thirdImageView sd_setImageWithURL:[NSURL URLWithString:_imageDataArray.firstObject] placeholderImage:nil];
            
        }
        
        
    }else if (_index ==_imageDataArray.count-1){
        if (_imageDataArray.count>1) {
            [firstImageView sd_setImageWithURL:[NSURL URLWithString:_imageDataArray[_index-1]] placeholderImage:nil];
        }else{
            
            [firstImageView sd_setImageWithURL:[NSURL URLWithString:_imageDataArray.firstObject] placeholderImage:nil];
            
        }
        [secondImageView sd_setImageWithURL:[NSURL URLWithString:_imageDataArray[_index]] placeholderImage:nil];
        [thirdImageView sd_setImageWithURL:[NSURL URLWithString:_imageDataArray.firstObject] placeholderImage:nil];
        
        
    }else{
         [firstImageView sd_setImageWithURL:[NSURL URLWithString:_imageDataArray[_index-1]] placeholderImage:nil];
        [secondImageView sd_setImageWithURL:[NSURL URLWithString:_imageDataArray[_index]] placeholderImage:nil];
        [thirdImageView sd_setImageWithURL:[NSURL URLWithString:_imageDataArray[_index+1]] placeholderImage:nil];
        
        
    }
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{

    [self scrollViewDidEndDecelerating:scrollView];

}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    int index= round(scrollView.contentOffset.x/self.bounds.size.width);
    
    switch (_scrolledType) {
        case ScrolledTypeCycle:{
            if (index > 1) {
                if (_index == self.imageDataArray.count-1) {
                    _index = 0;
                }else{
                    _index++;
                }
                
            }else if(index<1){
                
                if (_index == 0) {
                    _index = self.imageDataArray.count-1;
                }else{
                    _index--;
                }
            }
            [self.scrollView setContentOffset:CGPointMake(self.bounds.size.width, 0) animated:NO];
            self.pageControl.currentPage = self.index;
            [self changeImages];
        }
            break;
        case ScrolledTypeBack:
        case ScrolledTypeNO:{
            
            self.index = index;
            self.pageControl.currentPage = self.index;
            
        }
            break;
            
        default:
            break;
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

   
    [self.timer invalidate];

}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self setUpTimer];

}
-(void)clickImageView:(UITapGestureRecognizer *)tap{
    if (_delegate && [_delegate respondsToSelector:@selector(CycleScrollViewClickAtIndex:)]) {
        [_delegate CycleScrollViewClickAtIndex:self.index];
    }
}
@end
