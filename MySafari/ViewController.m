//
//  ViewController.m
//  MySafari
//
//  Created by tim on 3/11/15.
//  Copyright (c) 2015 Timothy Yeh. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIWebViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.webView.delegate = self;
}

- (void) performLoadURLRequest:(NSString *)string
{
    NSURL *url = [[NSURL alloc] initWithString:string];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:request];
}

#pragma mark UITextFieldDelegate Protocols

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self performLoadURLRequest:textField.text];
    return YES;
}

@end
