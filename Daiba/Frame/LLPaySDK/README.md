LLPaySDK iOS接入指南
=========

### 文件说明
---

1. 内部包含 LLPay 的支付SDK
2. [LLPaySDK_iOS下载](http://open.lianlianpay.com/#cat=33)
3. 文件夹内文件说明

	|文件				|文件内容|
	|-------------		|----------------|
	|LLPaySdk.h			|	头文件，声明接口|
	|libLLTokenPaySDK.a	|	单独的LLPay 的 lib库|
	|walletResources.bundle|	LianlianPay 资源包,**请勿改名**|
	

### 下面是基本的接入指南：
---

1. 导入文件
2. 添加头文件引用 #import "LLPaySdk.h"
3. 设置link标志
	- Target->Build Setting ，Other Linker Flags 设置为 -all_load
	- 可能添加-all_load以后和其他库冲突，可以尝试使用 -force_load 单独load库, force_load后面跟的是 lib库的完整路径

	```
	- -force_load $(SRCROOT)/***/libLLPaySDK.a (****需要按照你的库放置的路径决定)
	```

4. 调用sdk显示，注意strong修饰，自动释放以后，调用后会导致程序崩溃或者有些图片会消失（如导航栏返回图片等）

	```
	NSDictionary *orderParam = @{*****}; // 创建订单
	self.sdk = [LLPaySdk sharedSdk]; // 创建SDK
	NSMutableDictionary *paymentInfo = [NSMutableDictionary dictionary]; //包含Token字段的字典
	//组织paymentInfo
	[[LLPaySdk sharedSdk] payApply:self.currentPaymentInfo
	                          inVC:self
	                    completion:^(LLPayResult result, NSDictionary *dic) {
		//根据result和dic作出不同处理
	}];
	```

### LLPaySDK可配置部分
---


> iOS SDK可以通过修改资源bundle进行定制， 因为是在bundle里面，请在修改好以后 **clean proj**，这样才会生效。

1. 图片的替换，在内部的图片可以替换修改为自己的样式
2. 颜色等的修改，可以修改default.css文件，支持#abcdef，123,123,123两种颜色表示
3. 修改值意义列表

	|修改的对象	|修改方法|
	|--------	|-------|
	|导航栏颜色	|替换ll_nav_bg3.png文件，以及修改css文件中NavBar字段（后面只表示字段，都是在default.css文件中）中的background-color|
	|导航栏标题	|NavBar字段中的titleIconName; titleText|
    |签约或支付弹窗标题|PayAlert字段|
	


4. 参数字段部分
	- 参数说明在demo中有，可以参考。字段名和wap不一致，请参考Demo中的参数说明，参数中的user_id 不是商户号，是商户自己体系中的用户编号，前置卡输入时，no_agree是通过API查询得到的绑卡序号
  
5. 使用部分
	- Demo中的输入项，是用来测试各种支付条件，包括认证支付（输入姓名，身份证），前置支付（输入卡号，协议号）。不是必须，请根据自己的支付方式测试。
	- 支持银行数量，是根据支付类型以及商户来，可以配置，请联系运营。


### 常见问题
---

[连连支付对接常见问题](http://test.yintong.com.cn/asklianlian/)

1. **运行直接崩溃**

	- 1、sdk没有retain保管。
	- 2、sdk中使用了类扩展，请在other Linker Flags中添加 -all_load		

2. **提示初始化错误**

	- 1、检查环境和商户号等是否匹配；
	- 2、检查签名方法是否正确（参考签名工具）；
	- 3、订单信息是否有遗漏项；

3. 所传的类型**不是NSString**
	- 解释：连连的订单需要传入的订单格式为{"strkey": "strvalue", "strkey1" : "strvalue2"}，请不要传递 {"key": [v1, v2]} 或者 {"key": {"ikey":"v"}} 这种
	- 应对，修改订单内值的格式，特别是risk_item，需要变成 {"risk_item":"{\"r_key\":\"v\"}"}这样，由于有些信息商户是由后台传入，请*保证使用后台传给客户端的值也是NSString类型*

4. 商户**无此支付产品权限**

	- 解释：我们的产品分为认证支付、快捷支付等多种支付方式。一种支付方式对应的包、支付调用方法、商户号都有所不同。
	- 应对：先检查商户号是否是正确的商户号，比如   <认证支付测试商户号  201408071000001543>  <快捷支付测试商户号  201408071000001546>
		然后检查所对应的包或者调用方法对不对。

5. 商户**无此支付权限**
	
	- 解释：一个商户号对应的商品业务类型是有限的。
	- 应对：修改  商户业务类型 busi_partner 是 String(6) 
		- 虚拟商品销售：101001
 		- 实物商品销售：109001
 		- 外部账户充值：108001

6. 签名验证不对
	- [签名验证错误解决](http://test.yintong.com.cn/asklianlian/?cat=10)
	- 解释：签名有特定规则，订单里面的特定参数参与签名。
	- 应对：ios最新的Demo中提供了payUtil函数，直接调用，就能生成签名正确的订单。然后再次提醒，我们**强烈建议商户在服务器端完成签名操作**。


