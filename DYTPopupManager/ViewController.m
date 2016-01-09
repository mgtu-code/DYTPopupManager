//
//  ViewController.m
//  DYTPopupManager
//
//  Created by mg on 15/9/22.
//  Copyright (c) 2015年 dayoo. All rights reserved.
//

#import "ViewController.h"
#import "DYTPopupManager.h"
#import "PViewController.h"

@interface ViewController ()<DYTPopupManagerDelegate>

@property (nonatomic,strong) DYTPopupManager *popupManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 320, 568)];
    
    [imageView setImage:[UIImage imageNamed:@"bg2"]];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.view addSubview:imageView];
    
    UIButton *openButton = [UIButton buttonWithType:UIButtonTypeSystem];
    openButton.frame = CGRectMake(110, 80, 100, 30);
    [openButton setTitle:@"打开view" forState:UIControlStateNormal];
    [openButton addTarget:self action:@selector(openView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:openButton];
    
    UIButton *openButton2 = [UIButton buttonWithType:UIButtonTypeSystem];
    openButton2.frame = CGRectMake(90, 130, 140, 30);
    [openButton2 setTitle:@"打开viewController" forState:UIControlStateNormal];
    [openButton2 addTarget:self action:@selector(openViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:openButton2];
    
    self.popupManager = [[DYTPopupManager alloc] init];
    self.popupManager.delegate = self;
}

-(void)openView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 200)];
    //[self.popupManager showPopupViewIn:self popupView:view style:DYTPopupStyleCancelButton position:DYTPopupPositionCenter];
    [self.popupManager showPopupViewWithView:view style:DYTPopupStyleNone maskStyle:DYTPopupMaskStyleBlur position:DYTPopupPositionBottom animation:YES];
}

-(void)openViewController{
    PViewController *viewController = [[PViewController alloc] init];
    [self.popupManager showPopupViewWithViewController:viewController style:DYTPopupStyleCancelButton maskStyle:DYTPopupMaskStyleGray position:DYTPopupPositionBottom animation:NO];
}

#pragma mark - DYTPopupManagerDelegate
-(void)dyt_popupViewWillPresent:(UIView *)popupView{
    NSLog(@"popupViewWillPresent");
    
}

-(void)dyt_popupViewDidPresent:(UIView *)popupView{
    NSLog(@"popupViewDidPresent");
}

-(void)dyt_popupViewWillDismiss:(UIView *)popupView{
    NSLog(@"popupViewWillDismiss");
}

-(void)dyt_popupViewDidDismiss:(UIView *)popupView{
    NSLog(@"popupViewDidDismiss");
}

@end
