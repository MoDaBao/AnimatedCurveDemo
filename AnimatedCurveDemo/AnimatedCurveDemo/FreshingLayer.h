//
//  FreshingLayer.h
//  AnimatedCurveDemo
//
//  Created by M on 2017/12/12.
//  Copyright © 2017年 dabao. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface FreshingLayer : CALayer

/**
 *  CurveLayer的进度 0~1
 */
@property(nonatomic,assign)CGFloat progress;

@end
