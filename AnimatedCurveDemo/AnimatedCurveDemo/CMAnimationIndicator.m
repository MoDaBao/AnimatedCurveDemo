//
//  CMAnimationIndicator.h
//  CMRead-iPhone
//

#import "CMAnimationIndicator.h"
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

@interface CMAnimationIndicator ()<UIGestureRecognizerDelegate>

@end

@implementation CMAnimationIndicator

-(UIColor *)colorWithHexString:(NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];

        _infolabel = [[UILabel alloc]init];
        _infolabel.backgroundColor = [UIColor clearColor];
        _infolabel.textAlignment = NSTextAlignmentCenter;
        _infolabel.textColor = [self colorWithHexString:@"#333333"];
        _infolabel.text = @"休息，休息一下喽";
        _infolabel.font = [UIFont systemFontOfSize:18.0f];
        [self addSubview:_infolabel];
        
        _btnLabel = [[UILabel alloc]init];
        _btnLabel.backgroundColor = [UIColor clearColor];
        _btnLabel.textAlignment = NSTextAlignmentCenter;
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"网络不给力，点击重试"];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0f] range:[[str string]rangeOfString:@"网络不给力，点击重试"]];
        [str addAttribute:NSForegroundColorAttributeName value:[self colorWithHexString:@"#666666"] range:[[str string]rangeOfString:@"网络不给力，"]];
        [str addAttribute:NSForegroundColorAttributeName value:[self colorWithHexString:@"#f38200"] range:[[str string]rangeOfString:@"点击重试"]];
        [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:[[str string]rangeOfString:@"点击重试"]];
        _btnLabel.attributedText = str;
        [self addSubview:_btnLabel];
        
        _refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_refreshBtn addTarget:self action:@selector(refreshAgainButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_refreshBtn];
        
        self.layer.hidden = YES;
        
        UITapGestureRecognizer* tapRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapped:)];
        tapRecognizer.delegate=self;
        tapRecognizer.numberOfTapsRequired=2;
        [self addGestureRecognizer:tapRecognizer];
    }
    return self;
}

- (void)startAnimation
{
    self.alpha = 1;
    self.layer.hidden = NO;
    //[self doAnimation];
}

- (void)doAnimation
{
    
    _infolabel.text = _loadtext;
    _btnLabel.text = _btntext;
    
    //设置动画总时间
    _imageView.animationDuration = 0.6;
    //设置重复次数,0表示不重复
    _imageView.animationRepeatCount = 0;
    //开始动画
    [_imageView startAnimating];
}

- (void)stopAnimation
{
    [_imageView stopAnimating];
    self.layer.hidden = YES;
    
//    [UIView animateWithDuration:0.3f animations:^{
//        self.alpha = 0;
//    } completion:^(BOOL finished) {
//        [_imageView stopAnimating];
//        self.layer.hidden = YES;
//        self.alpha = 1;
//    }];
}

- (void)stopAnimationWithLoadText:(NSString *)text withType:(BOOL)type;
{
    _infolabel.text = text;
    if(type){
        
        [UIView animateWithDuration:0.3f animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [_imageView stopAnimating];
            self.layer.hidden = YES;
            self.alpha = 1;
        }];
    }else{
        [_imageView stopAnimating];
    }
}

- (void)startTurnAnimation{
    [_indicationView setHidden:NO];
    [_indicationView startAnimating];
}

- (void)stopTurnAnimation{
    [_indicationView setHidden:YES];
    [_indicationView stopAnimating];
}


- (void)setLoadStyle:(LoadViewStyle)style
{
    switch (style) {
        case LoadViewStyleLoading:
        {
            //设置动画帧
            UIImage *firstImage = [UIImage imageNamed:@"common_loading_progress_1"];
            _imageView.image = firstImage;//不设置，截屏时会没有内容
            _imageView.frame = CGRectMake((self.frame.size.width - firstImage.size.width)/2,(self.frame.size.height/2 - firstImage.size.height), firstImage.size.width, firstImage.size.height);
            _imageView.animationImages = [NSArray arrayWithObjects:firstImage,
                                         [UIImage imageNamed:@"common_loading_progress_2"],
                                         [UIImage imageNamed:@"common_loading_progress_3"],
                                         nil ];
            _infolabel.frame = CGRectMake(0, _imageView.frame.origin.y + _imageView.frame.size.height + 10, self.frame.size.width, 20);
        }
            break;
        case LoadViewStyleFailure:
        {
            UIImage *firstImage = [UIImage imageNamed:@"no_internet_icon"];
            _imageView.image = firstImage;//不设置，截屏时会没有内容
            _imageView.frame = CGRectMake((self.frame.size.width - firstImage.size.width)/2, (self.frame.size.width - firstImage.size.width)/2, firstImage.size.width, firstImage.size.height);
            _imageView.animationImages = [NSArray arrayWithObjects:firstImage,
                                         [UIImage imageNamed:@"no_internet_icon"],
                                         nil ];
            _infolabel.frame = CGRectMake(0, _imageView.frame.origin.y + _imageView.frame.size.height + 15, self.frame.size.width, 20);
            _btnLabel.frame = CGRectMake(0, _infolabel.frame.origin.y + _infolabel.frame.size.height +15, self.frame.size.width, 20);
            _refreshBtn.frame = CGRectMake(SCREEN_WIDTH/2 + 10, _infolabel.frame.origin.y + _infolabel.frame.size.height +15, 65, 20);
        }
            break;
        case LoadViewStylePageTurn:
        {
//            UIImage *firstImage = [UIImage imageNamed:@"common_loading_pageturn_12"];
//            _imageView.frame = CGRectMake((self.frame.size.width - firstImage.size.width)/2, (self.frame.size.height/2 - firstImage.size.height), firstImage.size.width, firstImage.size.height);
//            _imageView.animationImages = [NSArray arrayWithObjects:firstImage,
//                                         [UIImage imageNamed:@"common_loading_pageturn_11"],
//                                         [UIImage imageNamed:@"common_loading_pageturn_10"],
//                                         [UIImage imageNamed:@"common_loading_pageturn_9"],
//                                         [UIImage imageNamed:@"common_loading_pageturn_8"],
//                                         [UIImage imageNamed:@"common_loading_pageturn_7"],
//                                         [UIImage imageNamed:@"common_loading_pageturn_6"],
//                                         [UIImage imageNamed:@"common_loading_pageturn_5"],
//                                         [UIImage imageNamed:@"common_loading_pageturn_4"],
//                                         [UIImage imageNamed:@"common_loading_pageturn_3"],
//                                         [UIImage imageNamed:@"common_loading_pageturn_2"],
//                                         [UIImage imageNamed:@"common_loading_pageturn_1"],
//                                         nil ];
            self.layer.hidden=NO;
            UIImage* image=[UIImage imageNamed:@"read_loading_logo"];
            _imageView.bounds=CGRectMake(0, 0, image.size.width, image.size.height);
            _imageView.center=CGPointMake(self.center.x, self.center.y-54);
            [_imageView setImage:image];
            if (_indicationView==nil) {
                _indicationView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                _indicationView.frame=CGRectMake((self.bounds.size.width-24)/2, _imageView.frame.origin.y+_imageView.frame.size.height+33, 24, 24);
                [self addSubview:_indicationView];
            }
            [_indicationView setHidden:YES];
            [_indicationView stopAnimating];
        }break;
        default:
            break;
    }

}

- (void)setLoadText:(NSString *)text;
{
    if(text){
        _loadtext = text;
    }
}

- (void)setBtnText:(NSString *)text;
{
    if(text){
        _btntext = text;
    }
}

- (void)setBackgroundColorValue:(int)value{
  
    _backgroundValue=value;
}

- (void)drawRect:(CGRect)rect{

    [super drawRect:rect];
        
}

-(void)refreshAgainButtonClicked{
    if (_delegate && [_delegate respondsToSelector:@selector(refreshAgainButtonClicked)]) {
        [_delegate refreshAgainButtonClicked];
    }
}

#pragma mark- GestureRecognizer
- (void)handleTapped:(UITapGestureRecognizer*)recognizer
{
//    if (_delegate&&[_delegate respondsToSelector:@selector(animationIndicatorViewDidTapped:)]) {
//        
//        [_delegate animationIndicatorViewDidTapped:self];
//        
//    }
}
@end
