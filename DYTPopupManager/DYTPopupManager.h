//
//  DYTPopupManager.h
//  DYTPopupManagerDemo
//
//  Created by mg on 15/9/20.
//  Copyright (c) 2015年 dayoo. All rights reserved.
//


/**
 * DYTPopupManager：弹窗组件
 */
#import <UIKit/UIKit.h>
#import "DYTPopupFrameView.h"


/**
 * DYTPopupManagerDelegate 弹窗协议，调用弹窗的ViewController遵循这协议，可以在弹窗弹出前后、隐藏前后触发
 */
@protocol DYTPopupManagerDelegate <NSObject>

@optional
/**
 * 弹窗弹出前
 */
-(void)dyt_popupViewWillPresent:(UIView *)popupView;

/**
 * 弹窗弹出后
 */
-(void)dyt_popupViewDidPresent:(UIView *)popupView;

/**
 * 弹出隐藏前
 */
-(void)dyt_popupViewWillDismiss:(UIView *)popupView;

/**
 * 弹出隐藏后
 */
-(void)dyt_popupViewDidDismiss:(UIView *)popupView;

@end


@interface DYTPopupManager : NSObject

/**
 * 点击遮罩层是否隐藏主View层，默认值：YES
 */
@property (nonatomic,assign) BOOL isHiddenByClickMaskView;

/**
 * 点击遮罩层是否隐藏主View层，默认值：YES
 */
@property (nonatomic,readonly) BOOL isPopupViewShow;

/**
 * DYTPopupManagerDelegate：popupManager的协议
 */
@property (nonatomic,weak) id<DYTPopupManagerDelegate>delegate;

#pragma mark - init
/**
 * 初始化
 */
-(instancetype)init;

#pragma mark - public
/**
 * 显示弹窗(View)
 * @params UIView *popupView：即将被弹出的View
 * @params DYTPopupStyle style：弹窗层的样式，默认无关闭按钮
 * @params DYTPopupMaskStyle maskStyle：弹窗遮罩层样式，默认黑色半透明层
 * @params DYTPopupPosition position：弹窗出现位置，默认底部
 * @params BOOL animation：是否有弹窗进入过渡动画
 */
-(void)showPopupViewWithView:(UIView *)popupView style:(DYTPopupStyle)style maskStyle:(DYTPopupMaskStyle)maskStyle position:(DYTPopupPosition)position animation:(BOOL)animation;

/**
 * 显示弹窗(ViewController)
 * @params UIViewController *popupViewController：即将被弹出的ViewController
 * @params DYTPopupStyle style：弹窗层的样式，默认无关闭按钮
 * @params DYTPopupMaskStyle maskStyle：弹窗遮罩层样式，默认黑色半透明层
 * @params DYTPopupPosition position：弹窗出现位置，默认底部
 * @params BOOL animation：是否有弹窗进入过渡动画
 */
-(void)showPopupViewWithViewController:(UIViewController *)popupViewController style:(DYTPopupStyle)style maskStyle:(DYTPopupMaskStyle)maskStyle position:(DYTPopupPosition)position animation:(BOOL)animation;

/**
 * 隐藏弹窗
 * @params BOOL animation：是否有弹窗退出过渡动画
 */
-(void)hiddenPopupViewWithAnimation:(BOOL)animation;;

@end
