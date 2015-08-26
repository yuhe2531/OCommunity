/*****************************************************************
 * 版权所有：  (2014)
 * 文件名称： BKDefine.h
 * 内容摘要： 宏定义
 * 其它说明：
 * 编辑作者：
 * 版本编号：1.0
 * Copyright (c) 2014年 bitcare. All rights reserved.
 ****************************************************************/

#ifndef EAssistant_BKDefine_h
#define EAssistant_BKDefine_h

/**
 *  微信开放平台申请得到的 appid, 需要同时添加在 URL schema
 */
#define WXAppId @"wxd930ea5d5a258f4f"

/**
 * 微信开放平台和商户约定的支付密钥
 *
 * 注意：不能hardcode在客户端，建议genSign这个过程由服务器端完成
// */
//#define WXAppKey @"L8LrMqqeGRxST5reouB0K66CaYAWpqhAVsq7ggKkxHCOastWksvuX1uvmvQclxaHoYd3ElNBrNO2DHnnzgfVG9Qs473M3DTOZug5er46FhuGofumV8H2FVR9qkjSlC5K"

/**
 * 微信开放平台和商户约定的密钥
 *
 * 注意：不能hardcode在客户端，建议genSign这个过程由服务器端完成
 */
//#define WXAppSecret @"db426a9829e4b49a0dcac7b4162da6b6"

/**
 * 微信开放平台和商户约定的支付密钥
 *
 * 注意：不能hardcode在客户端，建议genSign这个过程由服务器端完成
 */
//#define WXPartnerKey @"8934e7d15453e97507ef794cf7b0519d"

/**
 *  微信公众平台商户模块生成的ID
 */
//#define WXPartnerId @"1900000109"

#define ORDER_PAY_NOTIFICATION @"OrderPayNotification"

#define AccessTokenKey @"access_token"
#define PrePayIdKey @"prepayid"
#define errcodeKey @"errcode"
#define errmsgKey @"errmsg"
#define expiresInKey @"expires_in"

#endif
