//
//  DYTPopupFrameView.m
//  DYTPopupManager
//
//  Created by mg on 15/9/22.
//  Copyright (c) 2015年 dayoo. All rights reserved.
//

#import "DYTPopupFrameView.h"
#import <Accelerate/Accelerate.h>


//遮罩层颜色
#define DYTPopupFrameView_maskView_backgroundColor [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1];
//弹窗层背景色
#define DYTPopupFrameView_frameView_backgroundColor [UIColor whiteColor];


//遮罩层模糊系数
static const CGFloat p_bgImageBlurRadius = 0.8;
//左右间距
static const CGFloat p_margin = 10;
//contentView间距
static const CGFloat p_contentMargin = 5;
//圆角大小
static const CGFloat DYPOPUPVIEWCONTROLLER_CORNERRADIUS = 4.0;
//关闭按钮高度
static const CGFloat p_cancelButtonHight = 30;


@interface DYTPopupFrameView ()

@property (nonatomic,strong) UIImageView *maskBgView;
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UIButton *cancelButton;

@property (nonatomic) CGFloat minFrameHeight;
@property (nonatomic) CGFloat maxFrameHeight;
@property (nonatomic) CGFloat minContentHeight;
@property (nonatomic) CGFloat maxContentHeight;

@end


@implementation DYTPopupFrameView
#pragma mark - init
-(instancetype)init{
    return [self initWithFrame:[UIScreen mainScreen].applicationFrame];
}

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initLayout];
    }
    return self;
}

-(void)initLayout{    
    //view配置
    self.backgroundColor = [UIColor clearColor];
    
    //遮罩层
    self.maskView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self.maskView addSubview:self.maskBgView];
    [self addSubview:self.maskView];
    
    //内容层
    [self addSubview:self.frameView];
    [self.frameView addSubview:self.contentView];
}

#pragma mark - public
/**
 * 将view添加到弹窗内容区
 */
-(void)addViewInContentView:(UIView *)view popupStyle:(DYTPopupStyle)style{
    _popupStyle = style;
    
    CGFloat frameViewHeight = [self p_frameViewActualHeight:view.frame.size.height];
    CGRect frameViewFrame = self.frameView.frame;
    self.frameView.frame = CGRectMake(frameViewFrame.origin.x, frameViewFrame.origin.y, frameViewFrame.size.width, frameViewHeight);
    
    CGFloat contentViewHeight = [self p_contentViewActualHeight:view.frame.size.height];
    CGRect contentViewFrame = self.contentView.frame;
    self.contentView.frame = CGRectMake(contentViewFrame.origin.x, contentViewFrame.origin.y, contentViewFrame.size.width, contentViewHeight);
    
    switch (_popupStyle) {
        case DYTPopupStyleCancelButton:{
            self.cancelButton.frame = CGRectIntegral(CGRectMake(0, self.frameView.frame.size.height-p_cancelButtonHight, self.frameView.frame.size.width, p_cancelButtonHight));
            [self.cancelButton addTarget:self action:@selector(p_hiddenFrameView:) forControlEvents:UIControlEventTouchUpInside];
            [self.frameView insertSubview:self.cancelButton aboveSubview:self.contentView];
            break;
        }
        case DYTPopupStyleNone:{
            [self.cancelButton removeFromSuperview];
            break;
        }
    }
    
    [self.contentView addSubview:view];    
}

/**
 * 移除弹窗内容区的所有子view
 */
-(void)removeSubViewsInContentView{
    [self.contentView.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
}

/**
 * 更新遮罩层（需在弹窗之前更新）
 */
-(void)updateMaskViewWithStyle:(DYTPopupMaskStyle)style{
    switch (style) {
        case DYTPopupMaskStyleGray:{
            self.frame = [UIScreen mainScreen].bounds;
            self.maskView.frame = self.frame;
            self.maskView.backgroundColor = DYTPopupFrameView_maskView_backgroundColor;
        }
            break;
        case DYTPopupMaskStyleBlur:{
            self.frame = [UIScreen mainScreen].applicationFrame;
            self.maskView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            self.maskBgView.frame = CGRectMake(0, 0, self.maskView.frame.size.width, self.maskView.frame.size.height);
            //卸载
            self.maskBgView.image = nil;
            
            //获取当前rootViewController的截屏
            UIWindow *keyWindow =  [[UIApplication sharedApplication] keyWindow];
            UIViewController *rootViewController = keyWindow.rootViewController;
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(rootViewController.view.bounds.size.width, rootViewController.view.bounds.size.height-20),YES,0);
            [rootViewController.view drawViewHierarchyInRect:CGRectMake(0, -20, rootViewController.view.bounds.size.width, rootViewController.view.bounds.size.height) afterScreenUpdates:NO];
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            rootViewController = nil;
            keyWindow = nil;
            
            //加载模糊后的截屏
            self.maskBgView.image = [self p_applyBlurOnImage:image withRadius:p_bgImageBlurRadius];
            image = nil;
        }
            break;
    }
}

/**
 * 获取弹窗视图的CGRect
 */
-(CGRect)getFrameViewRectForShow:(DYTPopupPosition)position{
    CGRect showFrameViewRect;
    if(position == DYTPopupPositionBottom){
        showFrameViewRect = CGRectIntegral(CGRectMake(p_margin, (self.frame.size.height-p_margin-self.frameView.frame.size.height), (self.frame.size.width-p_margin*2), self.frameView.frame.size.height));
    }else if(position == DYTPopupPositionCenter){
        showFrameViewRect = CGRectIntegral(CGRectMake(p_margin, (self.frame.size.height - self.frameView.frame.size.height)/2,(self.frame.size.width-p_margin*2), self.frameView.frame.size.height));
    }
    return showFrameViewRect;
}

#pragma mark - private
-(CGFloat)p_frameViewActualHeight:(CGFloat)viewHight{
    CGFloat frameViewHeight;
    switch (self.popupStyle) {
        case DYTPopupStyleNone:
            frameViewHeight = viewHight+p_contentMargin*2;
            break;
        case DYTPopupStyleCancelButton:
            frameViewHeight = viewHight+p_contentMargin*2+p_cancelButtonHight;
            break;
    }
    
    if(frameViewHeight <= self.minFrameHeight){
        return self.minFrameHeight;
    }else if (frameViewHeight > self.minFrameHeight && frameViewHeight < self.maxFrameHeight){
        return frameViewHeight;
    }else{
        return self.maxFrameHeight;
    }
}

-(CGFloat)p_contentViewActualHeight:(CGFloat)viewHight{
    CGFloat contentViewHight = viewHight;
    if(contentViewHight <= self.minContentHeight){
        return self.minContentHeight;
    }else if (contentViewHight > self.minContentHeight && contentViewHight < self.maxContentHeight){
        return contentViewHight;
    }else{
        return self.maxContentHeight;
    }
}

-(void)p_hiddenFrameView:(id)sender{
    if(sender == self.cancelButton){
        if([self.delegate respondsToSelector:@selector(hiddenViewByClickCancelButton)]){
            [self.delegate hiddenViewByClickCancelButton];
        }
    }else{
        if([self.delegate respondsToSelector:@selector(hiddenViewByClickMaskView)]){
            [self.delegate hiddenViewByClickMaskView];
        }
    }
}

-(UIImage *)p_applyBlurOnImage:(UIImage *)imageToBlur withRadius:(CGFloat)blurRadius{
    if ((blurRadius <= 0.0f) || (blurRadius > 1.0f)) {
        blurRadius = 0.5f;
    }
    int boxSize = (int)(blurRadius * 100);
    boxSize -= (boxSize % 2) + 1;
    
    CGImageRef rawImage = imageToBlur.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(rawImage);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(rawImage);
    inBuffer.height = CGImageGetHeight(rawImage);
    inBuffer.rowBytes = CGImageGetBytesPerRow(rawImage);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(rawImage) * CGImageGetHeight(rawImage));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(rawImage);
    outBuffer.height = CGImageGetHeight(rawImage);
    outBuffer.rowBytes = CGImageGetBytesPerRow(rawImage);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL,
                                       0, 0, boxSize, boxSize, NULL,
                                       kvImageEdgeExtend);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             CGImageGetBitmapInfo(imageToBlur.CGImage));
    if(error){
        NSLog(@"imageToBlur error");
    }
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGImageRelease(imageRef);
    
    return returnImage;
}

#pragma mark - touch handle
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch * touch = [[event allTouches] anyObject];
    if (touch.view == self.maskView) {
        [self p_hiddenFrameView:self.maskView];
    }
}

#pragma mark - getter
-(UIView *)maskView{
    if(_maskView == nil){
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _maskView.backgroundColor = DYTPopupFrameView_maskView_backgroundColor;
        _maskView.alpha = 0;
    }
    return _maskView;
}

-(UIImageView *)maskBgView{
    if(_maskBgView == nil){
        _maskBgView = [[UIImageView alloc] initWithFrame:self.maskView.frame];
        [_maskBgView setContentMode:UIViewContentModeScaleToFill];
    }
    return _maskBgView;
}

-(UIView *)frameView{
    if(_frameView == nil){
        _frameView = [[UIView alloc] initWithFrame:self.frameViewRectForHidden];
        _frameView.backgroundColor = DYTPopupFrameView_frameView_backgroundColor;
        _frameView.clipsToBounds = YES;
        _frameView.layer.cornerRadius = DYPOPUPVIEWCONTROLLER_CORNERRADIUS;
        _frameView.alpha = 0;
    }
    return _frameView;
}

-(UIView *)contentView{
    if(_contentView == nil){
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(p_contentMargin, p_contentMargin, (self.frameView.frame.size.width-p_contentMargin*2), (self.frameView.frame.size.height-p_contentMargin*2))];
    }
    return _contentView;
    
}

-(UIButton *)cancelButton{
    if(_cancelButton == nil){
        _cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelButton setBackgroundColor:[UIColor whiteColor]];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    }
    return _cancelButton;
}

-(CGRect)frameViewRectForHidden{
    if(_frameView){
        return CGRectIntegral(CGRectMake(p_margin, self.frame.size.height, (self.frame.size.width-p_margin*2), self.frameView.frame.size.height));
    }else{
        return CGRectIntegral(CGRectMake(p_margin, self.frame.size.height, (self.frame.size.width-p_margin*2), self.minFrameHeight));
    }
}

-(CGFloat)minFrameHeight{
    switch (_popupStyle) {
        case DYTPopupStyleNone:
            return p_contentMargin*2;
            break;
        case DYTPopupStyleCancelButton:
            return p_cancelButtonHight+p_contentMargin*2;
            break;
    }
}

-(CGFloat)maxFrameHeight{
    return self.frame.size.height-p_margin*2;
}

-(CGFloat)minContentHeight{
    return 0;
}

-(CGFloat)maxContentHeight{
    switch (_popupStyle) {
        case DYTPopupStyleNone:
            return self.maxFrameHeight-p_contentMargin*2;
            break;
        case DYTPopupStyleCancelButton:
            return self.maxFrameHeight-p_contentMargin*2-p_cancelButtonHight;
            break;
    }
}


@end
