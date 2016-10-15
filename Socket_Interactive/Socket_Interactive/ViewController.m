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

@end
