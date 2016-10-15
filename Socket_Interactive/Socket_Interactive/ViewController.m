//
//  ViewController.m
//  Socket_Interactive
//
//  Created by HM on 16/10/14.
//  Copyright © 2016年 HM. All rights reserved.
//

#import "ViewController.h"
#import <arpa/inet.h>
#import <netinet/in.h>
#import <sys/socket.h>


@interface ViewController ()
/**
 *  webview浏览器展示
 */
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (nonatomic,assign) int clientSocket;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self socketDemo];
}


- (void)socketDemo {
    
    //连接百度
    [self connectToServer:@"115.239.210.27" port:80];

    //发送HTTP格式请求
    NSString *requestStr =@"GET / HTTP/1.1\r\n"
    "Host: www.baidu.com\r\n"
    "Connection: close\r\n\r\n";
    
    //获取响应
    NSString *responseStr = [self sentAndRecv:requestStr];
    
    //分离响应体
//    第一种方式分割:
    NSRange range = [responseStr rangeOfString:@"\r\n\r\n"];
    NSString *htmlStr = [responseStr substringFromIndex:range.location+range.length];
    NSLog(@"%@",htmlStr);
//    第二种方式分割:
    NSArray * htmlArray = [responseStr componentsSeparatedByString:@"\r\n\r\n"];
    NSString * htmlStr2 = [htmlArray lastObject];
    NSLog(@"------------------------------------------");
    NSLog(@"%@",htmlStr2);
    
    
    //网页数据使用webview来显示
    //http://www.baidu.com/1.png ./1.png
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com/"];
    [self.webview loadHTMLString:htmlStr2 baseURL:url];
}

#pragma mark - 建立连接
- (void)connectToServer:(NSString *)ip port:(int)port{
    
    _clientSocket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    struct sockaddr_in addr;
    /* 填写sockaddr_in结构*/
    addr.sin_family = AF_INET;
    addr.sin_port = htons(port);
    addr.sin_addr.s_addr = inet_addr(ip.UTF8String);
    
    int connectResult = connect(_clientSocket, (const struct sockaddr *)&addr, sizeof(addr));
    
    if (connectResult == 0) {
        NSLog(@"连接成功");
    }
}

#pragma mark - 发送请求获取响应体数据
- (NSString *)sentAndRecv:(NSString *)msg {
    const char *str = msg.UTF8String;
    ssize_t sentLen = send(_clientSocket, str, strlen(str), 0);

    //数据的累加
    NSMutableString *mStr = [NSMutableString string];
    
    /*
     1.socket
     2.存放数据的缓冲区
     3.缓冲区长度。
     4.指定调用方式。 0
     返回值 接收成功的字符数
     */
    char *buf[1024];
    ssize_t recvLen = recv(_clientSocket, buf, sizeof(buf), 0);
    
    NSString *recvStr = [[NSString alloc] initWithBytes:buf length:recvLen encoding:NSUTF8StringEncoding];
    
    [mStr appendString:recvStr];
    
    // 不断的获取数据 判断的依据是recvLen
    while (recvLen != 0) {
        recvLen = recv(_clientSocket, buf, sizeof(buf), 0);
        
        NSString *recvStr = [[NSString alloc] initWithBytes:buf length:recvLen encoding:NSUTF8StringEncoding];
        
        [mStr appendString:recvStr];
    }
    return mStr.copy;
}
@end
