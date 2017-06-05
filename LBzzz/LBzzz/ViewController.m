//
//  ViewController.m
//  LBzzz
//
//  Created by fighting on 17/2/7.
//  Copyright © 2017年 labi. All rights reserved.
//

#import "ViewController.h"
#import "BaseViewController.h"
#import "LBNavTabbarView.h"

#define RandomColor [UIColor colorWithRed:(random()%255)/255.0 green:(random()%255)/255.0 blue:(random()%255)/255.0 alpha:1]

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad]; //
    [self creteUI];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)creteUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
#if 0
    NSMutableArray *vcArr = [NSMutableArray array];
    NSMutableArray *titleArr = [NSMutableArray array];
    for (int i =0; i<9; i++) {
        UIViewController *vc = [[UIViewController alloc] init];
        vc.view.backgroundColor = RandomColor;
        [vcArr addObject:vc];
        [titleArr addObject:[NSString stringWithFormat:@"条目%d",i+1]];
    }
    
    LBNavTabbarView * view = [[LBNavTabbarView alloc]initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 44) andVCArr:vcArr andTitleArr:titleArr lineHeight:2];
    
    [self.view addSubview:view];
#else
    NSMutableArray *viewArr = [NSMutableArray array];
    NSArray * colorArr = @[[UIColor redColor],[UIColor greenColor],[UIColor blackColor],[UIColor blueColor],[UIColor orangeColor],[UIColor yellowColor],[UIColor purpleColor],[UIColor whiteColor],[UIColor cyanColor]];
    NSArray * titleArr = @[@"香蕉",@"大苹果",@"小樱桃",@"橘子",@"pich",@"大鸭梨",@"第四点"];
    for (int i =0; i < titleArr.count; i++) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = colorArr[i];
        [viewArr addObject:view];
    }
    
    LBNavTabbarView * view = [[LBNavTabbarView alloc]initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 44) andViewArr:viewArr andTitleArr:titleArr lineHeight:2];
    
    [self.view addSubview:view];
#endif
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
