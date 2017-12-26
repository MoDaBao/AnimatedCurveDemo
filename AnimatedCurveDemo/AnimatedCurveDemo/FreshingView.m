//
//  FreshingView.m
//  AnimatedCurveDemo
//
//  Created by M on 2017/12/14.
//  Copyright © 2017年 dabao. All rights reserved.
//

#import "FreshingView.h"

@interface FreshingView ()

@property (nonatomic, strong) FreshingLayer *freshingLayer;



@end

@implementation FreshingView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setProgress:(CGFloat)progress {
    self.freshingLayer.progress = progress;
    [self.freshingLayer setNeedsDisplay];
}


// 在一个子视图将要被添加到另一个视图的时候
- (void)willMoveToSuperview:(UIView *)newSuperview {
    self.freshingLayer = [FreshingLayer layer];
//    self.freshingLayer.backgroundColor = [UIColor redColor].CGColor;
    self.freshingLayer.frame = self.bounds;
    self.freshingLayer.progress = 0.0f;
    [self.freshingLayer setNeedsDisplay];
    [self.layer addSublayer:self.freshingLayer];
}

@end
