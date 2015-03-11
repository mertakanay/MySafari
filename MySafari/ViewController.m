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
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.webView.delegate = self;
    self.urlTextField.delegate = self;
    self.activityIndicator.hidesWhenStopped = YES;
}

- (void) performLoadURLRequest:(NSString *)string
{
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

#pragma mark UITextFieldDelegate Protocols

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{

    NSLog(@"text URL is %@", textField.text);
    [self performLoadURLRequest:textField.text];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark UIWebViewDelegate Protocols



-(void)webViewDidStartLoad:(UIWebView *)webView
{
     [self.activityIndicator startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidesWhenStopped=YES;
}

@end
