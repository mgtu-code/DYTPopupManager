# DYTPopupManager
DYTPopupManager 是Objective-C编写的全局弹窗组件（可使用磨砂玻璃效果），支持View、ViewController的弹出，可配置弹出位置、弹窗样式、弹窗遮罩样式（黑色半透明、磨砂玻璃效果），并通过Delegate触发弹窗出现前、弹窗出现后、弹窗退出前、弹窗退出后事件。

语言：Objective-C
最低兼容版本：IOS 7.0或以上

支持基本参数：

typedef NS_ENUM(NSInteger, DYTPopupStyle){//DYTPopupStyle 弹窗样式，默认是无任何样式
    DYTPopupStyleNone = 0,
    DYTPopupStyleCancelButton
};

typedef NS_ENUM(NSInteger, DYTPopupMaskStyle){//DYTPopupMaskStyle 弹窗遮罩样式，默认是灰色
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

Demo示例：
self.popupManager = [[DYTPopupManager alloc] init];
self.popupManager.delegate = self;
UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 200)];
[self.popupManager showPopupViewWithView:view style:DYTPopupStyleNone maskStyle:DYTPopupMaskStyleBlur position:DYTPopupPositionBottom animation:YES];

