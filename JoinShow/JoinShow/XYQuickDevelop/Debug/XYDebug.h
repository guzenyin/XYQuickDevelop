//
//  XYDebug.h
//  JoinShow
//
//  Created by Heaven on 13-12-9.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//  Copy from bee Framework http://www.bee-framework.com

//#import "XYPrecompile.h"

// debug模式下的nslog

/*
 * 说明 仅在debug下才显示nslog
 */
#if (1 == __XYDEBUG__)
#undef	NSLogD
#undef	NSLogDD
#define NSLogD(fmt, ...) {NSLog((@"%s [Line %d] DEBUG: \n" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#define NSLogDD NSLogD(@"%@", @"");

#else
#define NSLogD(format, ...)
#define NSLogDD
#endif


#undef	PRINT_CALLSTACK
#define PRINT_CALLSTACK( __n )	[XYDebug printCallstack:__n];
// 断点
#undef	BREAK_POINT
#define BREAK_POINT()			[XYDebug breakPoint];

#undef	BREAK_POINT_IF
#define BREAK_POINT_IF( __x )	if ( __x ) { [XYDebug breakPoint]; }

#undef	BB
#define BB						[XYDebug breakPoint];

#import "XYPerformance.h"

@interface UIWindow(XYDebug)

+ (void)hookSendEvent;

@end

#import <Foundation/Foundation.h>

@interface XYDebug : NSObject

+(NSArray *) callstack:(NSUInteger)depth;

+(void) printCallstack:(NSUInteger)depth;
+(void) breakPoint;

@end

#pragma mark - BorderView
// uiview点击时 加边框
@interface BorderView : UIView
- (void)startAnimation;
@end



