//
//  CMAnimationIndicator.h
//  CMRead-iPhone
//

#import <UIKit/UIKit.h>



typedef NS_ENUM(NSUInteger, LoadViewStyle) {
    LoadViewStyleLoading,   //加载
    LoadViewStyleFailure,   //加载失败
    LoadViewStylePageTurn   //翻页
};

@class CMAnimationIndicator;


@protocol CMAnimationIndicatorDeleagte <NSObject>

@optional
- (void)animationIndicatorViewDidTapped:(CMAnimationIndicator*)indicator;
-(void)refreshAgainButtonClicked;

@end

@interface CMAnimationIndicator : UIView
{
    UIImageView *_imageView;
    UILabel *_infolabel;
    UILabel *_btnLabel;
    UIButton *_refreshBtn;
    UIActivityIndicatorView* _indicationView;
    int _backgroundValue;
}

@property (nonatomic, assign)NSString *loadtext;
@property (nonatomic, assign)NSString *btntext;
@property (nonatomic, assign)id<CMAnimationIndicatorDeleagte>delegate;

//use this to init
- (id)initWithFrame:(CGRect)frame;

- (void)setBackgroundColorValue:(int)value;

- (void)setLoadStyle:(LoadViewStyle)style;

- (void)setLoadText:(NSString *)text;

- (void)startAnimation;

- (void)stopAnimation;

- (void)startTurnAnimation;

- (void)stopTurnAnimation;

//- (void)stopAnimationWithLoadText:(NSString *)text withType:(BOOL)type;

@end
