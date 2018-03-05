//
//  CommonToolsDef.h
//  EJZG
//
//  Created by zhngyy on 16/8/3.
//  Copyright © 2016年 zhangyy. All rights reserved.
//

#ifndef CommonToolsDef_h
#define CommonToolsDef_h

/**
 *  这里面主要放的是一些公共方法的调用
 */

#define WEAK_SELF(instance)  __weak typeof(self) weakSelf = instance;

/*********************第三方appkey**********************/
#define MAMAP_SERVICE_APIKEY    @"2536f4af402494a767465a996b979ed9" //高德地图appkey
#define UMESSAGE_APPKEY         @"" // 友盟推送appkey


/*********************公共的Block**********************/
typedef void (^loginSuccess)();
typedef void (^PushBlock)(id Object);
typedef void (^Void_Block)(void);
typedef void (^Bool_Block)(BOOL value);
typedef void (^Int_Block)(NSInteger value);
typedef void (^Id_Block)(id obj);
typedef void (^Async_Block)(id responseDTO);
typedef BOOL (^GesRecognizer_Block)(UIGestureRecognizer*, UITouch*);
typedef void (^SelectIndexData)(id data,NSInteger index);
typedef void (^DataHelper_Block)(id obj, BOOL ret);
typedef void (^DataHelper_Block_Page)(id obj, BOOL ret, int pageNumber);
typedef void (^DataHelper_Block_Auth)(id obj, BOOL ret, NSInteger index);
typedef void (^Location_Block)(id currentLongitude,id currentLatitude);
typedef void (^BtnClickBlock)(UIButton *sender);
typedef void (^OrderbyBtnIndex)(UIButton *sender,BOOL isUp);
typedef void (^SelectStandardMessage)(NSString *selectStandardString);
/*****************************设备相关宏定义*********************************/

// 基本设备信息
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define INTERFACE_IS_PAD     ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define INTERFACE_IS_PHONE   ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)

#define DEVICE_WIDTH         ([[UIScreen mainScreen] bounds].size.width)
#define DEVICE_HEIGHT        ([[UIScreen mainScreen] bounds].size.height)


#define STATUSBAR_HEIGHT        20.f
#define NAVIGATIONBAR_HEIGHT    44.f
#define BOTTOMVIEW_HEIGHT       64.f
#define TABBAR_HEIGHT           49.f
#define DRAWER_LEFT_WIDTH       220.f


//查询条件高度
#define C_CONDITION_HEIGHT          40.0f
#define C_CONDITION_CONTENT_HEIGHT  200.0f
#define C_OK_BTN_HEIGHT             40.0f
#define C_OPARATION_HEIGHT          120.0f
#define C_SEARCHVIEW_HEIGHT         80.0f

// tabbar修改后的高度
#define CUSTOM_TABBAR_HEIGHT   49.0f


#define SCREEN_WIDTH         DEVICE_WIDTH
#define SCREEN_HEIGHT        (DEVICE_HEIGHT - STATUSBAR_HEIGHT)


#define SCREEN_SCALE         ([UIScreen mainScreen].scale)
#define kOnePixel (1 / SCREEN_SCALE)

#define UI_DENSITY           ([UIScreen mainScreen].scale) // 屏幕像素密度
#define UI_SCALE_X           (1.f)
#define UI_SCALE_Y           (1.f)
#define UI_SCALE_W           (DEVICE_WIDTH / 320.f)  // 组件宽度缩放比例
#define UI_SCALE_H           (1.f)                   // 组件高度缩放比例
#define UI_SCALE_WH          (1.f)
#define UI_LAYOUT_MARGIN     (12.f) // UI布局时的通用边距
#define UI_SCALE_W_H(wh)     (wh * SCREEN_WIDTH / 375.0f)              // 控件宽高缩放

#define UI_COMM_BTN_WIDTH    (DEVICE_WIDTH - 2 * UI_LAYOUT_MARGIN)      // 通用长按钮的宽度
#define UI_COMM_BTN_HEIGHT   (40.f)                                     // 通用按钮的高度
#define UI_COMM_SHORT_BTN_HEIGHT   (120.f)
/*************************************************************************/

/*********************************UI相关***********************************/
#define CGRectSize(rect)            rect.size
#define CGRectOrigin(rect)          rect.origin
#define CGRectWidth(rect)           rect.size.width
#define CGRectHeight(rect)          rect.size.height
#define CGRectOriginX(rect)         rect.origin.x
#define CGRectOriginY(rect)         rect.origin.y
#define CGRectCenter(rect)          (CGPointMake(CGRectWidth(rect)/2.f, CGRectHeight(rect)/2.f))

#define CGRectLeftBottomY(rect)     rect.size.height+rect.origin.y
#define CGRectRightTopX(rect)       rect.size.width+rect.origin.x


#define CGSizeWidth(size)           size.width
#define CGSizeHeight(size)          size.height
#define CGSizeCenter(size)          (CGPointMake(CGSizeWidth(size)/2.f, CGSizeHeight(size)/2.f))


#define UIColorFromHex(hexValue)    ([UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0])
#define UIColorFromHexA(hexValue,a)    ([UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:(a)])

#define RGBColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]

/*************************************************************************/

/**************************************页面布局相关********************************/

static const int TABLE_PAGE_SIZE = 8;
static const float UI_Comm_Margin = 12.f;       //边距
static const float UI_Comm_Margin_V = 12.f;       //边距


/*******************************************************************************/




/*************************数据保存、获取、删除***********************/

//偏好设置保存数据
#define SaveDefault(value,key) ([[NSUserDefaults standardUserDefaults]setValue:value forKey:key])

//获取数据
#define GetValueFromDefault(key)  ([[NSUserDefaults standardUserDefaults]objectForKey:key])

//删除数据
#define DeletTheKey(key) ([[NSUserDefaults standardUserDefaults]removeObjectForKey:key])

/*************************打印***********************/
#ifdef DEBUG
#define NSLog(FORMAT, ...) \
printf("\n*************************打印开始***********************\n时间：%s\n文件名：%s\n行数：%d\n方法名：%s\n打印的入参：%s\n*************************打印结束***********************\n", \
__TIME__,\
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], \
__LINE__,\
__PRETTY_FUNCTION__, \
[[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif


#endif /* CommonToolsDef_h */
