//
//  DYTPopupManager.m
//  DYTPopupManagerDemo
//
//  Created by mg on 15/9/20.
//  Copyright (c) 2015年 dayoo. All rights reserved.
//

#import "DYTPopupManager.h"


//动画时间
static const CGFloat p_duration = 0.3;


@interface DYTPopupManager ()<DYTPopupFrameViewDelegate>

@property (nonatomic,readwrite) BOOL isPopupViewShow;
@property (nonatomic,strong) UIWindow *alertLevelWindow;
@property (nonatomic,strong) DYTPopupFrameView *popupFrameView;
@property (nonatomic,strong) id popupView;
@property (nonatomic,strong) id popupViewController;
@property (nonatomic,assign) BOOL animation;
@property (nonatomic,assign) DYTPopupMaskStyle maskStyle;

@end


@implementation DYTPopupManager

#pragma mark - init
-(instancetype)init{
    if(self = [super init]){
        _isHiddenByClickMaskView = YES;
        _isPopupViewShow = NO;
        _animation = NO;
    }
    return self;
}

#pragma mark - public
/**
 * 显示弹窗(View)
 */
-(void)showPopupViewWithView:(UIView *)view style:(DYTPopupStyle)style maskStyle:(DYTPopupMaskStyle)maskStyle position:(DYTPopupPosition)position animation:(BOOL)animation{
    if(!self.isPopupViewShow){
        self.popupView = view;
        //卸载已有的view
        [self.popupFrameView removeSubViewsInContentView];
        
        //更新遮罩
        self.maskStyle = maskStyle;
        [self.popupFrameView updateMaskViewWithStyle:maskStyle];
        
        //加载view && 框架样式
        [self.popupFrameView addViewInContentView:view popupStyle:style];
        
        //显示windows
        self.alertLevelWindow.hidden = NO;
        [self.alertLevelWindow addSubview:self.popupFrameView];
        
        if([self.delegate respondsToSelector:@selector(dyt_popupViewWillPresent:)]){
            [self.delegate dyt_popupViewWillPresent:view];
        }
        
        //显示弹窗
        self.animation = animation;
        if(animation){
            [UIView animateWithDuration:p_duration
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 [self p_showPopupFrameViewWithPosition:position];
                             }
                             completion:^(BOOL finished) {
                                 if(finished){
                                     if([self.delegate respondsToSelector:@selector(dyt_popupViewDidPresent:)]){
                                         [self.delegate dyt_popupViewDidPresent:view];
                                     }
                                 }
                             }
            ];
        }else{
            [self p_showPopupFrameViewWithPosition:position];
            if([self.delegate respondsToSelector:@selector(dyt_popupViewDidPresent:)]){
                [self.delegate dyt_popupViewDidPresent:view];
            }
        }
        self.isPopupViewShow = !self.isPopupViewShow;
    }
}

/**
 * 显示弹窗(ViewController)
 */
-(void)showPopupViewWithViewController:(UIViewController *)popupViewController style:(DYTPopupStyle)style maskStyle:(DYTPopupMaskStyle)maskStyle position:(DYTPopupPosition)position animation:(BOOL)animation{
    self.popupViewController = popupViewController;
    [self showPopupViewWithView:popupViewController.view style:style maskStyle:maskStyle position:position animation:animation];
}

/**
 * 隐藏弹窗
 */
-(void)hiddenPopupViewWithAnimation:(BOOL)animation{
    if(self.isPopupViewShow){
        if([self.delegate respondsToSelector:@selector(dyt_popupViewWillDismiss:)]){
            [self.delegate dyt_popupViewWillDismiss:self.popupView];
        }
        
        if(animation){
            [UIView animateWithDuration:p_duration
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 [self p_hiddenPopupFrameView];
                             }
                             completion:^(BOOL finished) {
                                 if(finished){
                                     if([self.delegate respondsToSelector:@selector(dyt_popupViewDidDismiss:)]){
                                         [self.delegate dyt_popupViewDidDismiss:self.popupView];
                                     }
                                 }
                                 
                                 [self p_removePopupFrameView];
                             }
             ];
        }else{
            [self p_hiddenPopupFrameView];
            
            if([self.delegate respondsToSelector:@selector(dyt_popupViewDidDismiss:)]){
                [self.delegate dyt_popupViewDidDismiss:self.popupView];
            }
            
            [self p_removePopupFrameView];
        }
        self.isPopupViewShow =!self.isPopupViewShow;
    }
}

#pragma mark - private
-(void)p_showPopupFrameViewWithPosition:(DYTPopupPosition)position{
    if(self.maskStyle == DYTPopupMaskStyleBlur){
        self.popupFrameView.maskView.alpha = 1;
    }else{
        self.popupFrameView.maskView.alpha = 0.4;
    }
    self.popupFrameView.frameView.alpha = 1;
    self.popupFrameView.frameView.frame = [self.popupFrameView getFrameViewRectForShow:position];
}

-(void)p_hiddenPopupFrameView{
    self.popupFrameView.maskView.alpha = 0;
    self.popupFrameView.frameView.alpha = 0;
    self.popupFrameView.frameView.frame = self.popupFrameView.frameViewRectForHidden;
}

-(void)p_removePopupFrameView{
    //卸载frameView
    [self.popupFrameView removeFromSuperview];
    
    //隐藏windows
    self.alertLevelWindow.hidden = YES;
    
    //卸载已有的view
    [self.popupFrameView removeSubViewsInContentView];
    _popupViewController = nil;
    _popupView = nil;
    _popupFrameView = nil;
    _alertLevelWindow = nil;
}

#pragma mark - DYTPopupFrameViewDelegate
-(void)hiddenViewByClickCancelButton{
    [self hiddenPopupViewWithAnimation:self.animation];
}

-(void)hiddenViewByClickMaskView{
    if(self.isHiddenByClickMaskView){
        [self hiddenPopupViewWithAnimation:self.animation];
    }
}

#pragma mark - getter
-(UIWindow *)alertLevelWindow{
    if(_alertLevelWindow == nil){
        _alertLevelWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _alertLevelWindow.windowLevel = UIWindowLevelAlert;
        [_alertLevelWindow makeKeyAndVisible];
    }
    return _alertLevelWindow;
}

-(DYTPopupFrameView *)popupFrameView{
    if(_popupFrameView == nil){
        _popupFrameView = [[DYTPopupFrameView alloc] init];
        _popupFrameView.delegate = self;
    }
    return _popupFrameView;
}

@end
