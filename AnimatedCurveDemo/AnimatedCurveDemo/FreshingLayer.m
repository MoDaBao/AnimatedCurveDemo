//
//  FreshingLayer.m
//  AnimatedCurveDemo
//
//  Created by M on 2017/12/12.
//  Copyright © 2017年 dabao. All rights reserved.
//

#import "FreshingLayer.h"

#define Radius 10
#define centerY self.frame.size.height * .5
#define centerX self.frame.size.width * .5
#define lineLength 20
#define halfHeight centerY
#define arrowAngle M_PI / 6
#define arrowLength 4

@implementation FreshingLayer

- (void)drawInContext:(CGContextRef)ctx {
    [super drawInContext:ctx];
    
    UIGraphicsPushContext(ctx);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIBezierPath *arrowPath = [UIBezierPath bezierPath];
    
    
    // path1
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    path1.lineCapStyle = kCGLineJoinRound;
    path1.lineJoinStyle = kCGLineJoinRound;
    path1.lineWidth = 2.0f;
    if (self.progress <= .5) {
        CGPoint pointA = CGPointMake(centerX - Radius , halfHeight + lineLength + (halfHeight - lineLength) * (1 - self.progress * 2));
        CGPoint pointB = CGPointMake(pointA.x, pointA.y - lineLength);
        [path1 moveToPoint:pointA];
        [path1 addLineToPoint:pointB];
        
        // 箭头
        [arrowPath moveToPoint:pointB];
        [arrowPath addLineToPoint:CGPointMake(pointB.x - arrowLength * sinf(arrowAngle), pointB.y + arrowLength * cosf(arrowAngle))];
        [path1 appendPath:arrowPath];
    }  else {
        
        CGPoint pointA = CGPointMake(centerX - Radius , halfHeight + lineLength - lineLength * (self.progress * 2 - 1) );
        CGPoint pointB = CGPointMake(pointA.x, centerY);
        [path1 moveToPoint:pointA];
        [path1 addLineToPoint:pointB];
        
//        [path1 addArcWithCenter:CGPointMake(centerX, centerY) radius:Radius startAngle:M_PI endAngle:M_PI * 2 * (self.progress - .5) clockwise:NO];
        [path1 addArcWithCenter:CGPointMake(self.frame.size.width/2, centerY) radius:Radius startAngle:M_PI endAngle:M_PI + ((M_PI*9/10) * (self.progress-0.5)*2) clockwise:YES];
        
        // 箭头
        [arrowPath moveToPoint:path1.currentPoint];
        [arrowPath addLineToPoint:CGPointMake(path1.currentPoint.x - arrowLength*(cosf(M_PI_2 - arrowAngle  - ((M_PI*9/10) * (self.progress-0.5)*2))), path1.currentPoint.y + arrowLength*(sinf(M_PI_2 - arrowAngle - ((M_PI*9/10) * (self.progress-0.5)*2))))];
        [path1 appendPath:arrowPath];
        
    }
    
    
    // path2
    UIBezierPath *path2 = [UIBezierPath bezierPath];
    path2.lineCapStyle = path1.lineCapStyle;
    path2.lineJoinStyle = path1.lineJoinStyle;
    path2.lineWidth = path1.lineWidth;
    
    if (self.progress <= .5) {
        //
        CGPoint pointC = CGPointMake(centerX + Radius, lineLength + self.progress * 2 * (halfHeight - lineLength));
        CGPoint pointD = CGPointMake(pointC.x, pointC.y - lineLength);
        [path2 moveToPoint:pointD];
        [path2 addLineToPoint:pointC];
        
        // 箭头
        [arrowPath moveToPoint:pointC];
        [arrowPath addLineToPoint:CGPointMake(pointC.x + arrowLength * sinf(arrowAngle), pointC.y - arrowLength * cosf(arrowAngle))];
        [path2 appendPath:arrowPath];
        
    } else {
        
        CGPoint pointC = CGPointMake(centerX + Radius, centerY);
        CGPoint pointD = CGPointMake(pointC.x, pointC.y - lineLength + lineLength * (self.progress-0.5)*2);
        [path2 moveToPoint:pointD];
        [path2 addLineToPoint:pointC];
        
//        [path2 addArcWithCenter:CGPointMake(centerX, centerY) radius:Radius startAngle:0 endAngle:M_PI * 2 * (self.progress - .5) clockwise:YES];
        [path2 addArcWithCenter:CGPointMake(self.frame.size.width/2, (centerY)) radius:Radius startAngle:0 endAngle:(M_PI*9/10)*(self.progress-0.5)*2 clockwise:YES];
        
        // 箭头
        [arrowPath moveToPoint:path2.currentPoint];
//        [arrowPath addLineToPoint:CGPointMake(<#CGFloat x#>, <#CGFloat y#>)];
        [arrowPath addLineToPoint:CGPointMake(path2.currentPoint.x + arrowLength*(cosf(M_PI_2 - arrowAngle  - ((M_PI*9/10) * (self.progress-0.5)*2))), path2.currentPoint.y - arrowLength*(sinf(M_PI_2 - arrowAngle - ((M_PI*9/10) * (self.progress-0.5)*2))))];
        [path2 appendPath:arrowPath];
        
    }
    
    CGContextSaveGState(context);
    CGContextRestoreGState(context);
    
    [[UIColor blackColor] setStroke];
    [path1 stroke];
    [path2 stroke];
    
    
    UIGraphicsPopContext();
}

@end
