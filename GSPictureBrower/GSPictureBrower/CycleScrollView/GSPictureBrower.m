//
//  CycleScrollView.m
//  GSAdsScrollview
//
//  Created by zhangtao on 16/6/21.
//  Copyright © 2016年 BetaTown. All rights reserved.
//

#import "GSPictureBrower.h"
#import "UIImageView+WebCache.h"


#define TAG_ScrollViewImageView  11111


@interface GSPictureBrower ()<UIScrollViewDelegate>


@property (nonatomic, strong)UIPageControl *pageControl;
@property (nonatomic, strong)UIScrollView *scrollView;


@property (nonatomic, assign)BOOL stareScale;

@property (nonatomic, assign)UIScrollView *currentZoomScrollView;

@end

@implementation GSPictureBrower

-(id)initWithFrame:(CGRect)frame andImageDataArray:(NSArray *)imageDataArray andCurrentIndex:(NSInteger)currentIndex{

    if (self = [super initWithFrame:frame]) {
        
        self.imageDataArray = imageDataArray;
        self.currentIndex = currentIndex;
        

    }
    return self;

}
-(id)initWithFrame:(CGRect)frame{
    
    if (self == [super initWithFrame:frame]) {
        

        self.backgroundColor = [UIColor clearColor];
        
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
        self.pageControl.currentPage = _currentIndex;
    }
    
    self.scrollView.contentSize = CGSizeMake(self.bounds.size.width*_imageDataArray.count, self.bounds.size.height);
    
    for (int i=0; i<_imageDataArray.count; i++) {
        
        
        UIScrollView *zoomScollView = [[UIScrollView alloc]initWithFrame:CGRectMake(self.bounds.size.width*i, 0, self.bounds.size.width, self.bounds.size.height)];
        [self.scrollView addSubview:zoomScollView];
        zoomScollView.maximumZoomScale = 3;
        zoomScollView.minimumZoomScale = 1.0;
        zoomScollView.delegate = self;
        zoomScollView.showsHorizontalScrollIndicator = NO;
        zoomScollView.showsVerticalScrollIndicator = NO;
        zoomScollView.bounces = NO;
        zoomScollView.contentSize = zoomScollView.frame.size;
        zoomScollView.tag = TAG_ScrollViewImageView+i;
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:zoomScollView.bounds];
   
        if ([self.imageDataArray[i] isKindOfClass:[NSString class]]) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageDataArray[i]]];
        }else if ([[self.imageDataArray[i] class] isKindOfClass:[NSURL class]]) {
            
            [imageView sd_setImageWithURL:self.imageDataArray[i]];
            
        }else if ([[self.imageDataArray[i] class] isKindOfClass:[UIImage class]]) {
            
            imageView.image = self.imageDataArray[i];
            
        }

        [zoomScollView addSubview:imageView];
        
        
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImageView:)];
        [imageView addGestureRecognizer:tap];
        
        UITapGestureRecognizer *recoveryTap =  [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(recoveryScaleIdentify:)];
        recoveryTap.numberOfTapsRequired = 2;
        [imageView addGestureRecognizer:recoveryTap];
        [tap requireGestureRecognizerToFail:recoveryTap];
        
    }
    
}

#pragma mark - zoom

-(void)recoveryScaleIdentify:(UITapGestureRecognizer *)tap{
    
    UIScrollView *scrollView = (UIScrollView *)tap.view.superview;
    
    CGFloat scale = scrollView.zoomScale;
    if (scale!=1) {
        scale = 1;
        
    }else{
    
        scale = scrollView.maximumZoomScale;
    }
    
    
    [UIView animateWithDuration:0.3 animations:^{
        scrollView.zoomScale = scale;
        _stareScale = NO;
    }];
    

    
}-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    if (scrollView == self.scrollView) {
        return nil;
    }
    
    _currentZoomScrollView = scrollView;
    return scrollView.subviews.firstObject;
    
    
}
-(CGSize)imageScaleSizeWithImage:(UIImageView *)imageView

{
    
        
        CGSize imageSize = imageView.image.size;
        CGSize imageViewSize = imageView.bounds.size;
        
        CGSize scaleSize = imageSize;
            //判断imageView的宽和高根据小的适配
        if (imageViewSize.width<imageViewSize.height) {
            //判断图片的宽高，根据大的适配小的
            if (imageSize.width != imageViewSize.width) {
               
                scaleSize.width = imageViewSize.width;
                scaleSize.height = imageViewSize.width/imageSize.width *imageSize.height;
                
            }
            
            if (scaleSize.height > imageViewSize.height) {
                
               
                scaleSize.width =imageViewSize.height/scaleSize.height*scaleSize.width;
                scaleSize.height = imageViewSize.height;
            }
            
            
    
            
            }else{
                if (imageSize.height!=imageViewSize.height) {
                    scaleSize.height = imageViewSize.height;
                    
                    scaleSize.width = imageViewSize.height/imageSize.height*imageSize.width;
                }
                
                if (scaleSize.width>imageViewSize.width) {
                    
                    
                    scaleSize.height = imageViewSize.width/scaleSize.width*scaleSize.height;
                    scaleSize.width = imageViewSize.width;
                }
                

            }
   

    
    return scaleSize;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
    _stareScale = YES;
    
    if (scrollView.zoomScale <= 1.0) {
        UIImageView *imageV = [scrollView.subviews firstObject];
        imageV.center = CGPointMake(scrollView.frame.size.width/2,scrollView.frame.size.height/2);
    }
    
}
-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    
    _stareScale = NO;

    
}
-(void)setCurrentIndex:(NSInteger)currentIndex{

    [self.scrollView setContentOffset:CGPointMake(self.frame.size.width*currentIndex, 0)];

}


#pragma mark - scroll
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView==self.scrollView) {
        
        int index= round(scrollView.contentOffset.x/self.bounds.size.width);
        
        if (index!=self.pageControl.currentPage) {
            _currentZoomScrollView.zoomScale = 1.0;
        }
        self.pageControl.currentPage = index;
        
        
        
    }else{
        if (_stareScale) {
            return;
        }
        
        UIImageView *imageView = scrollView.subviews.firstObject;
        CGSize scaleSize = [self imageScaleSizeWithImage:imageView];
        
        CGFloat offSetX = (CGRectGetWidth(scrollView.frame)-scaleSize.width)/2;
        CGFloat offSetY = (CGRectGetHeight(scrollView.frame)-scaleSize.height)/2;
        
        CGPoint contentOffset = scrollView.contentOffset;
        
        
        if (scaleSize.width*scrollView.zoomScale<=CGRectGetWidth(scrollView.frame)||scaleSize.height*scrollView.zoomScale<=CGRectGetHeight(scrollView.frame)) {
            if (offSetY>0) {
                
                if (scrollView.contentOffset.y>offSetY*scrollView.zoomScale) {
                    
                    contentOffset.y = offSetY*scrollView.zoomScale;
                    
                }
                if (scrollView.contentOffset.y<(offSetY+scaleSize.height)*scrollView.zoomScale-CGRectGetHeight(scrollView.frame)) {
                    
                    contentOffset.y =(offSetY+scaleSize.height)*scrollView.zoomScale-CGRectGetHeight(scrollView.frame);
                    
                }
            }
            
            if (offSetX>0) {
                
                if (scrollView.contentOffset.x>offSetX*scrollView.zoomScale) {
                    
                    contentOffset.x =offSetX*scrollView.zoomScale;
                }
                
                if (scrollView.contentOffset.x<(offSetX+scaleSize.width)*scrollView.zoomScale-CGRectGetWidth(scrollView.frame)) {
                    
                    contentOffset.x = (offSetX+scaleSize.width)*scrollView.zoomScale-CGRectGetWidth(scrollView.frame);
                }
                
            }
            
        }else{
            
            if (scaleSize.width*scrollView.zoomScale>CGRectGetWidth(scrollView.frame)) {
                
                if (scrollView.contentOffset.x>scrollView.zoomScale*offSetX+(scaleSize.width*scrollView.zoomScale-CGRectGetWidth(scrollView.frame))) {
                    
                    contentOffset.x =scrollView.zoomScale*offSetX+(scaleSize.width*scrollView.zoomScale-CGRectGetWidth(scrollView.frame));
                    
                }
                
                if (scrollView.contentOffset.x<offSetX*scrollView.zoomScale) {
                    contentOffset.x = offSetX*scrollView.zoomScale;
                }
                
                
                
            }
            
            if (scaleSize.height*scrollView.zoomScale>CGRectGetHeight(scrollView.frame)){
                if (scrollView.contentOffset.y>scrollView.zoomScale*offSetY+(scaleSize.height*scrollView.zoomScale-CGRectGetHeight(scrollView.frame))) {
                    
                    contentOffset.y = scrollView.zoomScale*offSetY+(scaleSize.height*scrollView.zoomScale-CGRectGetHeight(scrollView.frame));
                    
                }
                
                if (scrollView.contentOffset.y<offSetY*scrollView.zoomScale) {
                    contentOffset.y = offSetY*scrollView.zoomScale;
                }
                
                
            }
            
            
        }
        
        [scrollView setContentOffset:contentOffset];
    
    
    }
    
    

    
}



-(void)clickImageView:(UITapGestureRecognizer *)tap{
    
    if (_delegate && [_delegate respondsToSelector:@selector(GSPictureBrowerClickAtIndex:)]) {
        [_delegate GSPictureBrowerClickAtIndex:self.pageControl.currentPage];
    }


}

@end
