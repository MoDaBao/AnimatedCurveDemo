//
//  MORefreshingView.h
//  AnimatedCurveDemo
//
//  Created by M on 2017/12/7.
//  Copyright © 2017年 dabao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FreshingView.h"

@interface MORefreshingView : UIView

/**
 *  需要滑动多大距离才能松开
 */
@property (nonatomic, assign) CGFloat pullDistance;

/**
 *  停止刷新
 */
- (void)stopRefreshing;

- (instancetype)initAssociatedScrollView:(UIScrollView *)scrollView;

/**
 *  触发加载
 */
- (void)triggerRefreshing;
@end
