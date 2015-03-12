//
//  ViewController.m
//  MySafari
//
//  Created by tim on 3/11/15.
//  Copyright (c) 2015 Timothy Yeh. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIWebViewDelegate, UITextFieldDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (weak, nonatomic) IBOutlet UIButton *forwardButton;

@property (nonatomic) CGFloat contentY;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.webView.delegate = self;
    self.urlTextField.delegate = self;
    self.webView.scrollView.delegate = self;
    self.activityIndicator.hidesWhenStopped = YES;


    self.backButton.enabled = NO;
    self.forwardButton.enabled = NO;

    //self.webView.scrollView.scrollEnabled = TRUE;
    self.urlTextField.clearButtonMode = YES;

}

- (void) performLoadURLRequest:(NSString *)string
{
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (IBAction)onBackButtonPressed:(id)sender {

    [self.webView goBack];
}

- (IBAction)onPreviousButtonPressed:(id)sender {
    [self.webView goForward];
    }

- (IBAction)onStopButtonPressed:(id)sender {
    [self.webView stopLoading];
}

- (IBAction)onReloadButtonPressed:(id)sender {
    [self.webView reload];
}


- (IBAction)onPlusButtonPressed:(id)sender {
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"Coming Soon" message:nil delegate: self cancelButtonTitle:@"Ok" otherButtonTitles: nil, nil];

    [alertview show];
}


#pragma mark UIScrollViewDelegate protocols
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.contentY = scrollView.contentOffset.y;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(self.contentY >= scrollView.contentOffset.y)
    {
        self.urlTextField.alpha = 0.0;
    }
    else{
        self.urlTextField.alpha = 1.0;
    }
}

#pragma mark UITextFieldDelegate Protocols

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{

    NSString *urlString;
    NSLog(@"text URL is %@", textField.text);

    NSString *head = [textField.text substringToIndex:6];

    if(![head isEqualToString:@"http://"]){

        urlString = [NSString stringWithFormat:@"http://%@",textField.text];
    }

    [self performLoadURLRequest:urlString];
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


    if(webView.canGoBack == YES)
    {
        self.backButton.enabled = YES;
    }
    else
    {
        self.backButton.enabled = NO;
    }

    if(webView.canGoForward == YES)
    {
        self.forwardButton.enabled = YES;
    }
    else
    {
        self.forwardButton.enabled = NO;
    }


    NSLog(@" webview scroll enable? .....%i",webView.scrollView.scrollEnabled);

    if(webView.scrollView.dragging == YES)
    {
        NSLog(@"start dragging/scrolling in webview");
    }


    self.urlTextField.text = webView.request.URL.absoluteString;

    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

@end
