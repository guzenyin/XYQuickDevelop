#{XY} QuickDevelop

{XY} 快速开发框架是一个常用方法与常用第三方库的集合.

#### XYQuickDevelop
库的代码

XYTimer 定时器类.

XYDataLite 轻量形数据持久化, 基于NSUserDefaults

XYObserve KVO的简单封装

XYSandbox 沙箱路径

XYObjectCache 对象缓存类

---
XYParallaxHelper 实现类似ios7 视图差效果.

XYKeyboardHelper 弹出键盘时,移动所编辑的控件的通用解决方案

XYPopupViewHelper 弹出View,支持背景暗色和模糊效果

XYSpriteView 帧动画精灵类

XYSpriteHelper 精灵管理类

XYAnimate UIView动画的封装


#### XYExternal
所有的第三方库在这里,

第三方库的扩展在同目录的Extension里,如

* RequestHelper 网络通讯类.

---

## Installation
* 拷贝XYQuickDevelop到项目里
* 根据需要拷贝XYExternal到项目里
* 在XYExternalPrecompile.h关闭不需要的第三方库
* 根据说明设置文件 -fobjc-arc 或 -fno-objc-arc
* 添加本库以及第三方需要的framework
* 在需要用的文件或者pch里 `#import "XYQuickDevelop.h", #import "XYExternal.h"`
* 在 `XYPrecompile.h ,XYExternalPrecompile.h` 开启或者关闭需要的编译选项



---
### External 使用的第三方库
* 开启ARC: -fobjc-arc
* 无 ARC: -fno-objc-arc
* XYQuickDevelop 和 XYExternal/Extension 下面的文件都是MRC
* 参考了 [BeeFramework](https://github.com/gavinkwoe/BeeFramework/blob/master/document)

#### CocosDenshion 
* cocos2d音频管理
* 增加了播放音效循环的方法

#### OpenUDID
* UDID替代方案

#### MKNetWorkKit
* arc
* 网络请求

#### YYJSON
* arc
* json to object , object to json

#### LKDBHelper
* arc
* 基于FMDB
* sqlite 数据库全自动操作

---
#### MBProgressHUD
* 进度指示器

#### SVPullToRefresh
* arc
* 上拉刷新下拉加载

#### POViewFrameBuilder
* arc
* 自动布局