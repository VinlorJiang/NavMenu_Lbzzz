![DinPay logo](http://oq3ai2jdz.bkt.clouddn.com/DPApplePaySDK%E5%85%AC%E5%8F%B8logo.png)
# DragonPaySDK
* 使用智付龙支付 SDK 可快速、方便集成建行龙支付功能，本文档详细说明在接入智付龙支付 SDK 的过程中需要注意的地方。

## SDK集成流程详解

### 接入准备

*  需要接入的商户向智付商务人员申请并开通龙支付，获取商户 ID，密钥 Key (智付公钥)。

### 开发流程图

![开发流程图](http://oq3ai2jdz.bkt.clouddn.com/DragonPaySDK%E6%B5%81%E7%A8%8B%E5%9B%BE.png)

### DragonPaySDK 文件结构说明
* 静态库文件 DragonPaySDK.framework（包含模拟器与真机静态文件）结构如下：
![文件结构说明](http://oq3ai2jdz.bkt.clouddn.com/DragonPaySDK%E6%96%87%E4%BB%B6%E7%BB%93%E6%9E%84%E8%AF%B4%E6%98%8E.png)

###	DragonPaySDK 依赖关系
* 由于功能需要，DragonPaySDK 集成接入方需要导入三方库 openssl 结构目录如下：
![文件结构说明](http://oq3ai2jdz.bkt.clouddn.com/DragonPaySDK%E4%BE%9D%E8%B5%96%E5%85%B3%E7%B3%BB.png)

### iOS 9 设置

*  由于 Apple 在 iOS 9 系统上的要求，APP 需要在 info.plist 文件中设置以下的参数: DragonPaySDK 本身是支持 https 的。

![iOS 9 设置](http://oq3ai2jdz.bkt.clouddn.com/DPApplePaySDKiOS%209%E9%85%8D%E7%BD%AE.png)

### DragonPaySDK 集成

* 请在你的工程目录结构中，右键选择 Add -> Existing Files…，选择文件 DragonPaySDK.framework 或者将文件拖入 Xcode 工程目录结构中，在弹出的界面中勾选 Copy items into destination group's folder(if needed),并确保 Add To Targets 勾选相应的 target。同理把三方库 openssl 导入工程。在工程 Build Settings -> Header Search Paths 中配置 openssl 的路径。

### Xcode 工程中 Info 文件配置

* URL Schemes 填智付分配给商家的 APP 唯一标识符：


## 功能使用

* 在需要调用支付的控制器页面导入以下头文件：
```
   #import <DragonPaySDK/DPDragonPayManager.h>
   #import <DragonPaySDK/DPDragonPayResult.h>
```

### 支付接口

* 支付接口如下，调用智付龙支付接口需要从智付网关预下单获取智付 Token。将 Token，智付公钥，商家订单ID 传入 SDK，并实现代理方法接收支付结果。

~~~ objective-c
/**
 *  开始支付
 *
 *  @param token            支付后台返回的流水号
 *  @param publicKey        智付给商家的公钥
 *  @param orderID          商家订单ID
 *  @param delegate         实现 DPDragonPayResultDelegate
 */
-(void)payWithToken:(NSString *)token
          publicKey:(NSString *)publicKey
            orderID:(NSString *)orderID
           delegate:(id<DPDragonPayResultDelegate>)delegate;
~~~


### 支付结果代理

* 支付结果回调函数

~~~ objective-c
//支付结果回调函数
-(void)DragonPayResult:(DPDragonPayResult *)payResult;
~~~

* 支付结果通过代理返回。返回的结果为 DPDragonPayResult 对象，支付结果对象包含以下两个参数:

```
//支付状态
@property DPDragonPayResultStatus  payResultStatus;
//支付情况信息
@property (nonatomic,strong) NSDictionary *payResultInfoDic;
```
   * payResultInfoDic为 支付情况信息，包含成功或失败、支付金额、币种； 
payResultStatu s为支付状态成功、失败或者其它情况，该状态为枚举类型，状态码如下，用户根据不同的状态做处理；

```
//支付状态
typedef NS_ENUM(NSInteger,DPDragonPayResultStatus){
    DPDragonPayResultStatusSuccess,  //支付成功
    DPDragonPayResultStatusFailure,  //支付失败
    DPDragonPayResultStatusUnknown,  //交易已发起，状态不确定，商户需查询商户后台确认支付状态
    DPDragonPayResultStatusParamError, //参数不能为空
    DPDragonPayResultStatusTimeOut, //支付超时，状态不确定，商户需查询商户后台确认支付状态
    DPDragonPayResultStatusInvalidPayURL,//网关返回唤醒建行APP的URL无效
    DPDragonPayResultStatusAttestationError,//验签失败
};
```
 

    
## 注意事项

*   导入 DragonPaySDK 务必添加 libcrypto.a 和 libssl.a,如编译有异常请先确保该 .a 文件添加正常。
* TARGETS    Build Settings  Enable Bitcode 设置为 NO。
