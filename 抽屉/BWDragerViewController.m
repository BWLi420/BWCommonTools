//
//  BWDragerViewController.m
//  抽屉效果
//
//  Created by lbw on 16/9/9.
//  Copyright © 2016年 mortal. All rights reserved.
//

#import "BWDragerViewController.h"

@interface BWDragerViewController ()


@end

#define screenW [UIScreen mainScreen].bounds.size.width

@implementation BWDragerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加子控件
    [self addChild];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    //添加手势
    [self.mainV addGestureRecognizer:pan];
    
    
    //添加点按手势
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    [self.view addGestureRecognizer:tapGes];
    

}

- (void)close {
    //小于,复位.
    [UIView animateWithDuration:0.25 animations:^{
        
        self.mainV.frame = self.view.bounds;
    }];
}

#define target screenW * 0.8
//当手指手动时调用
- (void)pan:(UIPanGestureRecognizer *)pan {

    //获取偏移量
    CGPoint transP = [pan translationInView:self.mainV];
    
    //对中间的View做平移
    //根据偏移量计算当前MainV的位置
    [self positionWithOffset:transP.x];
    
    //判断手势的状态
    if (pan.state == UIGestureRecognizerStateEnded) {
        //当手指松开时,判断x是否大于屏幕宽度一半.
        if (self.mainV.frame.origin.x > screenW * 0.5) {
            //如果大于,定位到右侧指定的位置
            //计算偏移量
            CGFloat offset = target - self.mainV.frame.origin.x;
            
            [UIView animateWithDuration:0.5 animations:^{
                [self positionWithOffset:offset];
            }];
            
        }else {
            //小于,复位.
            [self close];
        }

    }
    
    //清0
    [pan setTranslation:CGPointZero inView:self.mainV];

}

//根据偏移量计算当前MainV的位置
- (void)positionWithOffset:(CGFloat)offset {
    //self.mainV.transform = CGAffineTransformTranslate(self.mainV.transform, offset, 0);
    //平移
    CGRect frame = self.mainV.frame;
    frame.origin.x += offset;
    self.mainV.frame = frame;
    
    //如果小于0,就不动
    if (self.mainV.frame.origin.x <= 0) {
        self.mainV.frame = self.view.bounds;
    }
    
    //缩放
    //计算缩放比例
    //最大值为0.3
    //什么情况下最大:当x等于屏幕宽度时为最大,最大为0.3
    //0,0.1,0.2,0.3
    CGFloat scale = self.mainV.frame.origin.x * 0.3 / screenW;
    scale = 1 - scale;
    NSLog(@"%f",scale);
    self.mainV.transform = CGAffineTransformMakeScale(scale, scale);
    
}


//添加子控件
- (void)addChild {
    //下面
    UIView *leftV = [[UIView alloc] initWithFrame:self.view.bounds];
    leftV.backgroundColor = [UIColor blueColor];
    [self.view addSubview:leftV];
    _leftV = leftV;
    //上面
    UIView *mainV = [[UIView alloc] initWithFrame:self.view.bounds];
    mainV.backgroundColor = [UIColor redColor];
    [self.view addSubview:mainV];
    _mainV = mainV;
    
}


@end
