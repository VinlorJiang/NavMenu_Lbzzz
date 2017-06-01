![DinPay logo](http://a1.qpic.cn/psb?/V11RDE5l45xcCs/eBXD7tZLqfMQLGkjTuGL*y0h.yvmb8NM2M5SHoUaQNE!/b/dFYBAAAAAAAA&bo=PAA7AAAAAAADByU!&rf=viewer_4)
# DinPayPlugin
* 智付手机支付插件为第三方授权商户提供移动互联网的产品支付功能。推荐使用信用卡支付，少数借记卡需要开通无卡支付，开通无卡支付演示请参见。<http://online.unionpay.com/static/help/detail_129.html>

## 接口说明

### 新版智付支付插件启动方法：
``` objective-c
/**
 *  新版启动智付的支付插件
 *
 *  @param order          传入的order对象
 *  @param schemeStr      调用支付的app注册在info.plist中的scheme
 *  @param mode           支付环境
 *  @param viewController 启动支付控件的viewController
 *  @param delegate       DinPayPluginDelegate
 *  @return 返回成功失败
 */
+ (void)startDinPay:(Order*)order
         fromScheme:(NSString *)schemeStr
               mode:(NSString*)mode
     viewController:(UIViewController*)viewController
           delegate:(id<DinPayPluginDelegate>)delegate;

```

### 接口参数说明如下表：

| 参数名称        | 类型                       | 含义                               |
|:-------  |:---------------|:-------------|
|order          | Order *                   |  <mark>必填项</mark>；Order 对象，商户传入的订单信息。 |
|schemeStr | NSString *| <mark>必填项</mark>；在info.plist中配置的URL Schemes。|
|mode           | NSString *                 | <mark>必填项</mark>；接入模式设定，两个值:@"00":代表接入生产环境（正式版本需要)；@"01"：代表接入开发测试环境（测试版本需要)。|
|viewController | UIViewController *        | <mark>必填项</mark>；商户应用程序调用智付手机支付插件的当前 UIViewController。|
|delegate       | id < DinPayPluginDelegate>|<mark>必填项</mark>；实现DinPayPluginDelegate方法。|

### Order对象的属性定义说明如下：

| 参数名称        |  类型                       | 含义                               |
|:-------        | :---------------                 |:-------------                            |
| merchant       |  NSString * | <mark>必填项</mark>；商家号，商户签约时，智付支付平台分配的唯一商家号。  |
| interface_version | NSString * | <mark>必填项</mark>；接口版本,固定值:V3.0。|
| sign_type | NSString *| <mark>必填项</mark>；支持RSA,RSA_S,不参与签名。|
| notify_url | NSString * | <mark>必填项</mark>；服务器异步通知地址 ,支付成功后，智付支付平台会主动通知商家系统，商家系统必须指定接收通知的地址。|
| order_no | NSString * |<mark>必填项</mark>；商户网站唯一订单号,由商户系统保证唯一性，最长64位字母、数字组。|
| order_time | NSString * |<mark>必填项</mark>；商户订单时间, 格式：yyyy-MM-dd HH:mm:ss。|
| oreder_amount | NSString * |<mark>必填项</mark>；商户订单总金额,该笔订单的总金额，以元为单位，精确到小数点后两位。|
| product_name | NSString * |<mark>必填项</mark>；商品名称，不超过100个字符。|
| product_code | NSString * |<mark>可选项</mark>；商品编号，不超过60个字符。|
| product_num |  NSString * |<mark>可选项</mark>；商品数量。|
| product_desc | NSString * |<mark>可选项</mark>；商品描述，不超过300个字符。|
| extra_ return_param  | NSString * |<mark>可选项</mark>；商户支付成功时回传该参数。|
| redo_flag | NSString * |<mark>可选项</mark>；1 订单号不允许重复； 0 订单号允许重复。|
| idNumber | NSString * |<mark>可选项</mark>；用户身份证号码；跨境订单<mark>必填项</mark>参数( idNumer 和 userName 必须同时传输)。|
| userName | NSString * |<mark>可选项</mark>；用户姓名；跨境订单<mark>必填项</mark>参数( idNumer 和 userName 必须同时传输)。|

## 添加SDK包

### 1. 右键单击工程，通过菜单中 Add Files to 将 DPPlugin.h、DinPayPluginDelegate.h 和 DinPayPlugin3.1.0.a, Base64 文件夹添加到工程中。
### 2. 添加 QuartzCore.framework、Security.framework 和 libstdc++.dylib,libz.dylib 到工程中. 
### 3. 在工程的 info.plist 中添加 URL_Schemes:

``` 
	<key>CFBundleURLTypes</key>
	    <array>
		<dict>
			<key>CFBundleTypeRole</key>
			<string>Editor</string>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>用户自己定义</string>
			</array>
		</dict>
	</array>
```

### 4. 配置银联白名单：

```
	<key>LSApplicationQueriesSchemes</key>
	<array>
		<string>uppaysdk</string>
		<string>uppaywallet</string>
		<string>uppayx1</string>
		<string>uppayx2</string>
		<string>uppayx3</string>
	</array>
```

## 调用支付插件

### 1. 通过调用以下代码从而实现插件的调用

```
  +(void)startDinPay:(Order*)order
          fromScheme:(NSString *)schemeStr
                mode:(NSString*)mode
      viewController:(UIViewController*)viewController
            delegate:(id<DinPayPluginDelegate>)delegate;

```

### 2. 支付结果url处理:在应用的 AppDelegate 中调用 +(BOOL)handlePaymentResult:(NSURL*)url

```
 -(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
     return [DPPlugin handlePaymentResult:url];
 }

```
### 或者

```
   - (BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
     return [DPPlugin handlePaymentResult:url];
 }

```
### 3.处理支付结果
   * 智付手机支付控件有三个支付状态返回值：success、fail、cancel，分别代表：支
付成功、支付失败、用户取消支付。这三个返回状态值以字符串的形式作为回调函数参数 (NSString * )result 返回。 通 过 在工程中添加头文件
“DinPayPluginDelegate.h”，在处理交易结果的界面，实现 DinPayPluginDelegate
方法，根据该头文件中的回调函数：-(void)DinPayPluginResult:(NSString*)result
来实现回调方法，从而可以根据支付结果的不同进行相关的处理。

### 4. 注意事项
  * 调用插件签名时，建议在服务端进行签名将 bcmail-jdk15-1.45.jar，bcprov-jdk15-1.45.jar，dinpayRsaSignAPI-2.7.10.jar，这几个包放在服务端调用 RSA 签名证书在商户后台获取。

## 常见问题

### 1.	由于支付控件使用到了 C、C++和 OC 混编的情况,所以商户工程引入 DPPlugin.h 头文件以后可能会出现链接错误。这个时候可以通过两种方式解决:
*	将涉及到引用 DPPlugin.h 的源文件的后缀名都改为.mm;
*	如果商户不想修改源文件的后缀名,可以在工程中添加一个空的继承自 NSObject 的类,并将文件.m 后缀名该改为.mm 即可。

### 2. 由于在 DinpayPluginDemo工程中添加了自定义的库文件 DinPayPlugin3.1.0.a,当编译 Demo 工程时,应该检查工程设置 Search Paths 里的 Framework Search Paths、Header Search Paths、Library Search Paths 的路径设置,看设置路径是否正确,另外 还要注意里边是否多余一些不确定的路径。

### 3. 在工程的 Build Settings 中找到 Other Linker Flags 中添加-ObjC 宏。

## 附录一服务异步通知

### 业务参数

|   参数    |   参数名称          |     类型（长度）        |     使用     |         说明           |
|  :-------  | :---------  |  :--------  | :----   |  :---    |
|  <mark>基本参数：</mark>              |||||
| merchant_code | 商家号| String(20) | <mark>必填项</mark> | 商户签约时，智付支付平台分配的唯一商家号，举例：1111110106。 |
| notify_type | 通知类型 | String | <mark>必填项</mark> | 取值如下：服务器异步通知：offline_notify。 |
| notify_id | 通知校验ID | String | <mark>必填项</mark> | 商建议商家系统接收到此通知消息后，用此校验ID向智付支付平台校验此通知的合法性,由32位不重复的数字、字母组成.举例：235dst58fd1dwe21354fdafdaesfdsaf。 |
| nterface_version | 接口版本 | String | <mark>必填项</mark> | 接口版本，固定值：V3.0 |
| sign_type | 签名方式 | String | <mark>必填项</mark> | 签名方式:,RSA或者RSA-S |
| sign | 签名 | String | <mark>必填项</mark> | 签名数据，具体仔细阅读签名规则. |
|  <mark>业务参数：</mark>              |||||
| order_no | 商户网站唯一订单号 | String(64) | <mark>必填项</mark> | 商户系统订单号，由商户系统保证唯一性，最长64位字母、数字组成，举例：1000201555。 |
| order_time | 商户订单时间 | Date | <mark>必填项</mark> | 商户订单时间，格式：yyyy-MM-dd HH:mm:ss，举例：2013-11-01 12:34:54。 |
| order_amount | 商户订单总金额 | Number | <mark>必填项</mark> | 该笔订单的总金额，以元为单位，精确到小数点后两位，举例：0.01。 |
| extra_ return_param | 公用回传参数 | String(100) | <mark>必填项</mark> | 如果支付请求时传递该参数，则通知商户支付成功时回传该参数，举例：智付。 |
| trade_no | 智付交易订单号 | String | <mark>必填项</mark> | 智付交易订单号，举例：1000004817。 |
| trade_time | 智付交易订单时间 | Date | <mark>必填项</mark> | 智付交易订单时间，格式为：yyyy-MM-dd HH:mm:ss，举例：2013-12-1 12:23:34。 |
| trade_status | 交易状态 | String | <mark>必填项</mark> | 该笔订单交易状态：SUCCESS 交易成功；FAILED 交易失败 |
| bank_code | 支付银行代码 | String | 可选项 | 用户实际选择的支付银行参见银行代码对照表，举例：ABC。 |
| bank_seq_no | 网银交易流水号 | String | 可选项 | 银行交易流水号，举例：2013060911235456。 |

* 说明：当通知类型为offline_notify，商户系统接收到通知后必须返回处理结果SUCCESS，如果不是这7个字符，支付平台会重发5次通知，如果通知成功（即收到SUCCESS响应），通知ID参数失效，重发5次通知后，通知ID参数也会失效。

## 附录二单笔交易查询接口

* 接口描述：定义商户网站与智付支付平台间的单笔交易查询接口。
* 接口参数定义如下： 请求地址: <https://query.dinpay.com/query>

|   参数    |   参数名称          |     类型（长度）        |     使用     |         说明           |
|  :-------  | :---------  |  :--------  | :----   |  :---    |
|  <mark>基本参数：</mark>              |||||
| service_type | 业务类型 | String | <mark>必填项</mark> | 固定值：single_ trade_query |
| merchant_code | 签名方式 | String(20) | <mark>必填项</mark> | 支付平台分配的唯一商家号 |
| interface_version | 接口版本 | String | <mark>必填项</mark> | 接口版本，固定值：V3.0 |
| sign_type | 签名方式 | String | <mark>必填项</mark> | 签名方式:,RSA或者RSA-S |
| sign | 签名方式 | String | <mark>必填项</mark> | 签名数据，具体请见签名规则。 |
|  <mark>业务参数：</mark>              |||||
| order_no | 商户网站唯一订单号 | String | <mark>必填项</mark> | 商户系统订单号 |
| trade_no | 智付交易订单号| String | 可选项 | 智付交易订单号 |

* 响应参数定义：

|   参数    |   参数名称          |     类型（长度）        |     使用     |         说明           |
|  :-------  | :---------  |  :--------  | :----   |  :---    |
|  <mark>基本参数：</mark>              |||||
| is_success | 查询是否成功 | String | <mark>必填项</mark> | 仅表示查询是否成功：T 代表成功；F 代表失败 |
| sign_type | 签名方式| String | <mark>必填项</mark> | 签名方式:,RSA或者RSA-S |
| sign | 签名方式 | String | <mark>必填项</mark> | 签名数据，具体请见签名规则。 |
| error_code | 错误码 | String | <mark>必填项</mark> | 当查询失败时才返回错误码 |
|  <mark>业务参数（is_success值为T）：</mark>              |||||
| merchant_code | 商家号 | String | <mark>必填项</mark> | 支付平台分配的唯一商家号 |
| order_no | 商户订单时间 | String | <mark>必填项</mark> | 商户系统订单号 |
| order_time | 商户订单时间| Date | <mark>必填项</mark>  | 商户订单时间，格式：yyyy-MM-dd HH:mm:ss |
| order_amount | 商户订单总金额 | Number | <mark>必填项</mark> | 该笔订单的总金额，以元为单位，精确到小数点后两位。 |
| trade_no | 智付交易订单号| String | <mark>必填项</mark>  | 智付交易订单号 |
| trade_time | 智付交易订单时间 | Date | <mark>必填项</mark>  | 智付交易订单时间，格式为：yyyy-MM-dd HH:mm:ss。 |
| trade_status | 交易状态| String | <mark>必填项</mark>  | 该笔订单交易状态：SUCCESS 交易成功；FAILED 交易失败；UNPAY 未支付。 |
| bank_code | 支付银行代码 | String | 可选项   | 用户实际选择的支付银行参见银行代码对照表。 |
| bank_seq_no | 网银交易流水号| String | 可选项 | 银行交易流水号。 |

   * 当查询成功时，以 XML 格式形式同步返回响应数据：
   
   ```
   <?xml version="1.0" encoding="UTF-8"?>
   <dinpay>
       <resopnse>
           <is_success>T</is_success>
           <sign_type>MD5</sign_type>
           <sign>56ae9c3286886f76e57e0993625c71fe</sign>
           <trade>
              <merchant_id>2181230245</merchant_id>
              <order_no>210023569</order_no>
              <order_time>2013-05-10 11:18:00</order_time>
              <order_amount>100.00</order_amount>
              <trade_no>128600</trade_no>
              <trade_time>2013-05-10 11:21:01</trade_time>
              <trade_status>SUCCESS</trade_status>
           </trade>
       </response>
   </dinpay>
   ```
   
   * 当查询失败时，以 XML 格式形式同步返回响应数据：
   
   ```
   <?xml version="1.0" encoding="UTF-8"?>
   <dinpay>
       <resopnse>
           <is_success>F</is_success>
           <error_code>TRADE_IS_NOT_EXIST</error_code>
       </response>
   </dinpay>
   ```



