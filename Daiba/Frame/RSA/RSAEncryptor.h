//
//  RSAEncryptor.h
//  CloudPush
//
//  Created by YouMeng on 2017/3/30.
//  Copyright © 2017年 YouMeng. All rights reserved.

/**
 *  终端测试指令
 *
 *  DES(ECB)加密
 *  $ echo -n hello | openssl enc -des-ecb -K 616263 -nosalt | base64
 *
 * DES(CBC)加密
 *  $ echo -n hello | openssl enc -des-cbc -iv 0102030405060708 -K 616263 -nosalt | base64
 *
 *  AES(ECB)加密
 *  $ echo -n hello | openssl enc -aes-128-ecb -K 616263 -nosalt | base64
 *
 *  AES(CBC)加密
 *  $ echo -n hello | openssl enc -aes-128-cbc -iv 0102030405060708 -K 616263 -nosalt | base64
 *
 *  DES(ECB)解密
 *  $ echo -n HQr0Oij2kbo= | base64 -D | openssl enc -des-ecb -K 616263 -nosalt -d
 *
 *  DES(CBC)解密
 *  $ echo -n alvrvb3Gz88= | base64 -D | openssl enc -des-cbc -iv 0102030405060708 -K 616263 -nosalt -d
 *
 *  AES(ECB)解密
 *  $ echo -n d1QG4T2tivoi0Kiu3NEmZQ== | base64 -D | openssl enc -aes-128-ecb -K 616263 -nosalt -d
 *
 *  AES(CBC)解密
 *  $ echo -n u3W/N816uzFpcg6pZ+kbdg== | base64 -D | openssl enc -aes-128-cbc -iv 0102030405060708 -K 616263 -nosalt -d
 *
 *  提示：
 *      1> 加密过程是先加密，再base64编码
 *      2> 解密过程是先base64解码，再解密
 */

#import <Foundation/Foundation.h>

@interface RSAEncryptor : NSObject

+ (instancetype)sharedEncryptionTools;

/**
 @constant   kCCAlgorithmAES     高级加密标准，128位(默认)
 @constant   kCCAlgorithmDES     数据加密标准
 */
@property (nonatomic, assign) uint32_t algorithm;
/**
 *  加密方法
 *  @param str   需要加密的字符串
 *  @param path  '.der'格式的公钥文件路径
 */
+ (NSString *)encryptString:(NSString *)str publicKeyWithContentsOfFile:(NSString *)path;

/**
 *  解密方法
 *  @param str       需要解密的字符串
 *  @param path      '.p12'格式的私钥文件路径
 *  @param password  私钥文件密码
 */
+ (NSString *)decryptString:(NSString *)str privateKeyWithContentsOfFile:(NSString *)path password:(NSString *)password;

/**
 *  加密方法
 *  @param str    需要加密的字符串
 *  @param pubKey 公钥字符串
 */
+ (NSString *)encryptString:(NSString *)str publicKey:(NSString *)pubKey;

/**
 *  解密方法
 *  @param str     需要解密的字符串
 *  @param privKey 私钥字符串
 */
+ (NSString *)decryptString:(NSString *)str privateKey:(NSString *)privKey;


#pragma mark - 加密方式
+ (instancetype)sharedRSACryptor;

/**
 *  生成密钥对
 *
 *  @param keySize 密钥尺寸，可选数值(512/1024/2048)
 */
- (void)generateKeyPair:(NSUInteger)keySize;

/**
 *  加载公钥
 *
 *  @param publicKeyPath 公钥路径
 *
 @code
 # 生成证书
 $ openssl genrsa -out ca.key 1024
 # 创建证书请求
 $ openssl req -new -key ca.key -out rsacert.csr
 # 生成证书并签名
 $ openssl x509 -req -days 3650 -in rsacert.csr -signkey ca.key -out rsacert.crt
 # 转换格式
 $ openssl x509 -outform der -in rsacert.crt -out rsacert.der
 @endcode
 */
- (void)loadPublicKey:(NSString *)publicKeyPath;

/**
 *  加载私钥
 *
 *  @param privateKeyPath p12文件路径
 *  @param password       p12文件密码
 *
 @code
 openssl pkcs12 -export -out p.p12 -inkey ca.key -in rsacert.crt
 @endcode
 */
- (void)loadPrivateKey:(NSString *)privateKeyPath password:(NSString *)password;

/**
 *  加密数据
 *
 *  @param plainData 明文数据
 *
 *  @return 密文数据
 */
- (NSData *)encryptData:(NSData *)plainData;

/**
 *  解密数据
 *
 *  @param cipherData 密文数据
 *
 *  @return 明文数据
 */
- (NSData *)decryptData:(NSData *)cipherData;


#pragma mark - 新的key value 加密方式
/**
 *  加密字符串并返回base64编码字符串
 *
 *  @param string    要加密的字符串
 *  @param keyString 加密密钥
 *  @param iv        初始化向量(8个字节)
 *
 *  @return 返回加密后的base64编码字符串
 */
- (NSString *)encryptString:(NSString *)string keyString:(NSString *)keyString iv:(NSData *)iv;

/**
 *  解密字符串
 *
 *  @param string    加密并base64编码后的字符串
 *  @param keyString 解密密钥
 *  @param iv        初始化向量(8个字节)
 *
 *  @return 返回解密后的字符串
 */
- (NSString *)decryptString:(NSString *)string keyString:(NSString *)keyString iv:(NSData *)iv;

@end
