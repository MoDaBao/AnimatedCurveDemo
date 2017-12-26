//
//  MORefreshingView.m
//  AnimatedCurveDemo
//
//  Created by M on 2017/12/7.
//  Copyright © 2017年 dabao. All rights reserved.
//

#import "MORefreshingView.h"

@interface MORefreshingView()

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, weak) UIScrollView *associatedScrollView;
@property (nonatomic, strong) FreshingView *freshingView;


@end

@implementation MORefreshingView {
    BOOL loading;
    BOOL willEnd;
    BOOL notTracking;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initAssociatedScrollView:(UIScrollView *)scrollView {
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, 375, 200);
        self.backgroundColor = [UIColor orangeColor];
        self.associatedScrollView = scrollView;
        [self setUp];
        
        [self.associatedScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        
//        [self.associatedScrollView insertSubview:self atIndex:0];
        [self.associatedScrollView insertSubview:self atIndex:0];
    }
    return self;
}

- (void)setUp {
    self.pullDistance = 99;
    
    self.freshingView = [[FreshingView alloc] initWithFrame:CGRectMake((self.frame.size.width - 60) * .5, (self.frame.size.height - 60) * .5, 60, 60)];
    [self addSubview:self.freshingView];
}

- (void)startRefreshing {
//    self.freshingView.transform = CGAffineTransformIdentity;
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = @(M_PI * 2);
    rotationAnimation.duration = .5f;
    rotationAnimation.autoreverses = NO;//每次动画后不倒回回放
    rotationAnimation.repeatCount = HUGE_VALF; //一个非常大的浮点数值，认为无限循环
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];// 动画速度  kCAMediaTimingFunctionLinear 线性（匀速）|
    [self.freshingView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)stopRefreshing {
//    self.progress = 1.0;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.associatedScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    } completion:^(BOOL finished) {

        [self.freshingView.layer removeAllAnimations];
        willEnd = NO;
        notTracking = NO;
        loading = NO;
    }];
}

- (void)triggerRefreshing {
    [self.associatedScrollView setContentOffset:CGPointMake(0, -self.pullDistance) animated:YES];
}


/**
 *  kvo接收通知
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint new = [change[@"new"] CGPointValue];
        if (new.y <= 0) {
            self.progress = MAX(0.0, MIN(fabs(new.y / self.pullDistance), 1.0));
        }
    }
    
}

- (void)setProgress:(CGFloat)progress {
    if (!self.associatedScrollView.tracking) {// 当ScrollView没有被触摸
        
    }
    
    self.center = CGPointMake(self.center.x, -fabs(self.associatedScrollView.contentOffset.y * .5));
    self.freshingView.progress = progress;
    // 比较值  用来判断下拉距离是否超过了设置的下拉最大距离
    CGFloat diff = fabs(self.associatedScrollView.contentOffset.y) - self.pullDistance;
    if (diff >= 0) {
        // 当scrollVIew下拉大于最大距离  是否释放刷新加载
        if (!self.associatedScrollView.tracking) {
            loading = YES;
            
            [UIView animateWithDuration:0.3 animations:^{
                self.associatedScrollView.contentInset = UIEdgeInsetsMake(self.pullDistance, 0, 0, 0);
                [self startRefreshing];
            } completion:^(BOOL finished) {



                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self stopRefreshing];
                });
            }];
        } else {
            loading = NO;
        }
        
        if (!loading) {
            CGFloat a = diff / self.pullDistance == 0 ? 1 : diff / self.pullDistance;
//            NSLog(@"a=%lf,progress=%lf",a,progress);
            self.freshingView.transform = CGAffineTransformMakeRotation(M_PI * a);
        }
        
    } else {
        // CGAffineTransformIdentity是系统提供的一个常量，/* The identity transform: [ 1 0 0 1 0 0 ]. */（和原图一样的transform）;
        self.freshingView.transform = CGAffineTransformIdentity;
    }
    
    
    
   
    
    
}



@end
