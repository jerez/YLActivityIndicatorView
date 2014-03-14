//
//  YLActivityIndicatorView.m
//  YLActivityIndicator
//
//  Created by Eric Yuan on 13-1-15.
//  Copyright (c) 2013年 jimu.tv. All rights reserved.
//

#import "YLActivityIndicatorView.h"
#define kDotSpacing 3.0f
#define kDotBorderWidth 1.0f

@implementation YLActivityIndicatorView
{
    float _dotSide;
    float _yOffset;
}

@synthesize hidesWhenStopped = _hidesWhenStopped;
@synthesize dotCount = _dotCount;
@synthesize duration = _duration;

- (void)setDefaultProperty
{
    _currentStep = 0;
    _dotCount = 4;
    _isAnimating = NO;
    _duration = .8f;
    _hidesWhenStopped = YES;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setDefaultProperty];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)init
{
    self = [self initWithFrame:CGRectMake(0, 0, 50, 15)];
    return self;
}

#pragma mark - public
- (void)startAnimating
{
    if (_isAnimating) {
        return;
    }
    _dotSide = MIN(self.frame.size.height-kDotBorderWidth*2, (self.frame.size.width/_dotCount) + ((_dotCount-1)*kDotSpacing) + ((_dotCount-1)*kDotBorderWidth*2));
    _yOffset = ((self.frame.size.height -_dotSide)/2) ;
    _timer = [NSTimer scheduledTimerWithTimeInterval:_duration/(_dotCount*2+1)
                                              target:self
                                            selector:@selector(repeatAnimation)
                                            userInfo:nil
                                             repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    _isAnimating = YES;
    
    if (_hidesWhenStopped) {
        self.hidden = NO;
    }
}

- (void)stopAnimating
{
    if (_timer)
    {
        [_timer invalidate];
        _timer = nil;
    }
    
    _isAnimating = NO;
    
    if (_hidesWhenStopped) {
        self.hidden = YES;
    }
}

- (BOOL)isAnimating
{
    return _isAnimating;
}

#pragma mark - drawing
- (UIColor*)currentBorderColor:(NSInteger)index
{
    if (_currentStep == index) {
        return [UIColor grayColor];
    } else if (_currentStep < index) {
        return [UIColor colorWithWhite: 0.80 alpha:1];
    } else {
        if (_currentStep - index == 1) {
            return [UIColor lightGrayColor];
        } else {
            return [UIColor colorWithWhite: 0.80 alpha:1];
        }
    }
}

- (UIColor*)currentInnerColor:(NSInteger)index
{
    if (_currentStep == index) {
        return [UIColor lightGrayColor];
    } else if (_currentStep < index) {
        return [UIColor colorWithWhite: 0.90f alpha:1];
    } else {
        if (_currentStep - index == 1) {
            return [UIColor colorWithWhite: 0.80f alpha:1];
        } else {
            return [UIColor colorWithWhite: 0.90f alpha:1];
        }
    }
}

- (CGRect)currentRect:(NSInteger)index
{
    //float x = (index*(_dotSide));
    float x = self.frame.size.width/(_dotCount*_dotSide+kDotSpacing);
    if (_currentStep == index) {
        return CGRectMake(x,_yOffset, _dotSide,_dotSide);
    }else{
        return CGRectMake(x,_yOffset+1,_dotSide-2,_dotSide-2);
    }
}

- (void)repeatAnimation
{
    _currentStep = ++_currentStep % (_dotCount*2+1);
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (int i = 0; i < _dotCount; i++) {
        [[self currentInnerColor:i] setFill];
        [[self currentBorderColor:i] setStroke];
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGRect rect = [self currentRect:i];
        CGPathAddEllipseInRect(path, nil, rect);
        
        CGContextBeginPath(context);
        CGContextAddPath(context, path);
        CGContextSetLineWidth(context, kDotBorderWidth);
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFillStroke);
        
        CGContextTranslateCTM(context, self.frame.size.width/_dotCount, 0);
        CGPathRelease(path);
    }
}

@end
