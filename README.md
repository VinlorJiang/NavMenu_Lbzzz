![DinPay logo](http://a1.qpic.cn/psb?/V11RDE5l45xcCs/eBXD7tZLqfMQLGkjTuGL*y0h.yvmb8NM2M5SHoUaQNE!/b/dFYBAAAAAAAA&bo=PAA7AAAAAAADByU!&rf=viewer_4)
# DPKuDouPaySDK
* 本文档详细说明在接入接入智付酷蚪 SDK 的过程中需要注意的地方。

## SDK集成流程详解

### 接入准备

*  需要接入的商户向智付商务人员申请并开通酷蚪支付，获取商户ID，密钥Key(智付公钥)。

### 开发流程图

![开发流程图](http://oq3ai2jdz.bkt.clouddn.com/%E9%85%B7%E8%9A%AA%E6%B5%81%E7%A8%8B%E5%9B%BE.jpg)

### DPKuDouPaySDK 文件结构说明

* 静态库文件 DPKuDouPaySDK.framework（包含模拟器与真机静态文件）结构如下：

![文件结构说明](http://oq3ai2jdz.bkt.clouddn.com/DPKuDouPaySDK%E6%96%87%E4%BB%B6%E7%BB%93%E6%9E%84%E8%AF%B4%E6%98%8E.png)

### DPKuDouPaySDK 依赖关系

* 处于功能需求的需要，DPInterPaySDK 集成需要以下动态库，接入方需要导入动态库：libxml2.tbd  和 libicucore.tbd，Xcode 6以下需要导入系统的 Framework 库 SystemConfiguration.framework。
![文件结构说明](http://oq3ai2jdz.bkt.clouddn.com/DPKuDouPaySDK9.png)
![文件结构说明](http://oq3ai2jdz.bkt.clouddn.com/DragonPaySDK%E4%BE%9D%E8%B5%96%E5%85%B3%E7%B3%BB.png)
![文件结构说明](http://oq3ai2jdz.bkt.clouddn.com/DPKuDouPaySDK11.png)


### iOS 9 设置

*  由于 Apple 在 iOS9 系统上的要求，APP 需要在 info.plist 文件中设置以下的参数: DPInterPaySDK 本身是支持 https 的。

![iOS 9 设置](http://oq3ai2jdz.bkt.clouddn.com/DPApplePaySDKiOS%209%E9%85%8D%E7%BD%AE.png)

### DPKuDouPaySDK 集成

* 请在你的工程目录结构中，右键选择 Add -> Existing Files…，选择文件 DPKuDouPaySDK.framework 或者将文件拖入 Xcode 工程目录结构中，在弹出的界面中勾选 Copy items into destination group's folder(if needed),并确保 Add To Targets 勾选相应的 target。同理把资源包 InterPay.bundle 和三方库 openssl 导入工程。在工程 Build Settings -> Header Search Paths 中配置 openssl 的路径。

## 功能使用

* 在需要调用支付的控制器页面导入头文件:

```
#import <DPKuDouPaySDK/DPKuDouPaySDK.h>
```


### 支付接口

* 支付接口如下，调用智付酷蚪接口需要从智付网关预下单获取智付 Token。将 Token，支付方式，唯一标示，商家控制器传入 SDK，并实现代理方法接收支付结果。

~~~ objective-c
/**
 *  开始支付
 *
 *  @param token   支付后台返回的流水号
 *  @param key   智付公钥
 *  @param methodPayment 商家APP发起的支付方式
 *  @param fromScheme 商家APP传入的唯一标示，如下图 URL types 中的标示
 *  @param viewController 启动支付控件的viewController
 *  @param delegate 实现 DPKuDouPayResultDelegate 方法的 UIViewController
 */
+(void)payWithToken:(NSString *)token
                key:(NSString *)key
      methodPayment:(NSString *)methodPayment
         fromScheme:(NSString *)fromScheme
     viewController:(UIViewController *)viewController
           delegate:(id<DPKuDouPayResultDelegate>)delegate;
~~~

![支付fromScheme](http://oq3ai2jdz.bkt.clouddn.com/DPKuDouPaySDK10.png)


### 支付结果

* 支付结果通过代理返回

~~~ objective-c
/**
 *  支付结果回调函数
 *
 *  @param  payResult
 */
-(void)KuDouPayResult:(DPKuDouPayResult *)payResult;

~~~

* 支付结果通过代理返回。返回的结果为 DPKuDouPayResult 对象，支付结果对象包含以下两个参数，PayDesc:返回的描述，未安装微信或者微信版本过低也会以此字符串告知 APP，payResultStatus 为支付状态，

``` objective-c
/** 支付状态*/
@property DPKuDouPayResultStatus  payResultStatus;
/** 信息*/
@property (nonatomic,strong) NSString *payDesc;

```
* 支付状态成功、失败或者其它情况，该状态为枚举类型，状态码如下，用户根据不同的状态做处理。

``` objective-c
/** 支付状态*/
typedef NS_ENUM(NSInteger, DPKuDouPayResultStatus) {
    
    DPKuDouPayResultStatusSuccess,  //支付成功
    DPKuDouPayResultStatusFailure,  //支付失败
    DPKuDouPayResultStatusMsgFailure,//支付失败，返回支付失败描述（如果有返回错误描述会回调到APP，如果描述为空，则返回“支付失败”）
    DPKuDouPayResultStatusCancel,  //支付取消
    DPKuDouPayResultStatusParamError, //参数错误
    DPKuDouPayResultStatusInitError, //初始化失败
};


```


## 注意事项

 *  导入 DPKuDouPaySDK 务必添加 libcrypto.a 和 libssl.a,如编译有异常请先确保该.a文件添加正常。
 * 在 Build Settings－> Enable Bitcode 改为 NO。
* 如下图所示，在 AppDelegate.m 中倒入头文件：
```
 #import <DPKuDouPaySDK/DPKuDouPaySDK.h>
```
并在代理方法正确设置回调 url，否则导致无法正常回调结果：

![回调设置](http://oq3ai2jdz.bkt.clouddn.com/DPKuDouPaySDK8.png)

