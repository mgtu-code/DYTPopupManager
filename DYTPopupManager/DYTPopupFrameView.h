//
//  DYTPopupFrameView.h
//  DYTPopupManager
//
//  Created by mg on 15/9/22.
//  Copyright (c) 2015年 dayoo. All rights reserved.
//


/**
 * DYTPopupFrameView 弹窗框架view
 */
#import <UIKit/UIKit.h>

/**
 * DYTPopupStyle 弹窗样式，默认是无任何样式
 */
typedef NS_ENUM(NSInteger, DYTPopupStyle){
    DYTPopupStyleNone = 0,
    DYTPopupStyleCancelButton
};

/**
 * DYTPopupMaskStyle 弹窗遮罩样式，默认是灰色
 */
typedef NS_ENUM(NSInteger, DYTPopupMaskStyle){
    DYTPopupMaskStyleGray = 0, //灰色
    DYTPopupMaskStyleBlur //模糊
};

/**
 * DYTPopupPosition 弹窗位置，默认是底部弹窗
 */
typedef NS_ENUM(NSInteger, DYTPopupPosition){
    DYTPopupPositionBottom = 0,
    DYTPopupPositionCenter
};


/**
 * DYTPopupFrameViewDelegate 点击遮罩层时候，隐藏弹窗
 */
@protocol DYTPopupFrameViewDelegate <NSObject>

@optional
-(void)hiddenViewByClickMaskView;

-(void)hiddenViewByClickCancelButton;

@end


@interface DYTPopupFrameView : UIView

@property (nonatomic,strong) UIView *maskView;
@property (nonatomic,strong) UIView *frameView;
@property (nonatomic) CGRect frameViewRectForHidden;
@property (nonatomic,assign) DYTPopupStyle popupStyle;
@property (nonatomic,weak) id<DYTPopupFrameViewDelegate> delegate;

#pragma mark - public
/**
 * 将view添加到弹窗内容区
 */
-(void)addViewInContentView:(UIView *)view popupStyle:(DYTPopupStyle)style;

/**
 * 移除弹窗内容区的所有子view
 */
-(void)removeSubViewsInContentView;

/**
 * 更新遮罩层（需在弹窗之前更新）
 */
-(void)updateMaskViewWithStyle:(DYTPopupMaskStyle)style;

/**
 * 获取弹窗视图的CGRect
 */
-(CGRect)getFrameViewRectForShow:(DYTPopupPosition)position;

@end






