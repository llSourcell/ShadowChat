//
//  SHChatPanel.m
//  ShadowChat
//
//  Created by qwerty or on 08/09/11.
//  Copyright 2011 uiop. All rights reserved.
//

#import "SHChatPanel.h"

@implementation SHChatPanel
@synthesize tfield, output, sendbtn;

- (SHIRCChannel *)chan
{
    return chan;
}

- (void)setChan:(SHIRCChannel *)chan_
{
    chan=chan_;
    [chan setDelegate:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    /*
     FIXME: hax
     */
    if (![textField inputAccessoryView]) {
        [textField setInputAccessoryView:[textField superview]];
        [textField becomeFirstResponder];
    }
    return YES;
}

- (void) viewWillDisappear:(BOOL)animated
{
    if ([tfield isFirstResponder]) {
        [tfield resignFirstResponder];
    }
    [chan release];
    [super viewDidDisappear:animated];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.length==1&&[[textField text]length]==1) {
        sendbtn.enabled=NO;
    } else if (range.length==0&&range.location==0)
    {
        sendbtn.enabled=YES;
    }
    return YES;
}


- (IBAction)sendMessagePlz
{
    [self textFieldShouldReturn:nil];
}

- (void)didRecieveMessageFrom:(NSString*)nick text:(NSString*)ircMessage
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    NSString *java = [NSString stringWithFormat:@"addMessage('%@','%@');",
                      [[nick stringByReplacingOccurrencesOfString:@"\'" withString:@"\\'"] stringByReplacingOccurrencesOfString:@"'" withString:@"\'"],
                      [[ircMessage stringByReplacingOccurrencesOfString:@"\'" withString:@"\\'"] stringByReplacingOccurrencesOfString:@"'" withString:@"\'"]];
    [output stringByEvaluatingJavaScriptFromString:java];
    [pool release];
}

- (void)didRecieveActionFrom:(NSString*)nick text:(NSString*)ircMessage
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    NSString *java = [NSString stringWithFormat:@"addAction('%@','%@');",
                      [[nick stringByReplacingOccurrencesOfString:@"\'" withString:@"\\'"] stringByReplacingOccurrencesOfString:@"'" withString:@"\'"],
                      [[ircMessage stringByReplacingOccurrencesOfString:@"\'" withString:@"\\'"] stringByReplacingOccurrencesOfString:@"'" withString:@"\'"]];
    [output stringByEvaluatingJavaScriptFromString:java];
    [pool release];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([[tfield text] isEqualToString:@""]) {
        return YES;
    }
    [chan parseAndEventuallySendMessage:[tfield text]];
    [tfield setText:@""];
    sendbtn.enabled=NO;
    return YES;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationItem] setTitle:[chan formattedName]];
    [output loadHTMLString:@"<html><head><script>function htmlEntities(str) { return String(str).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/\"/g, '&quot;'); } \
     function addMessage(nick, msg) { document.body.innerHTML += '<div><strong>' + htmlEntities(nick) + ':</strong> ' + htmlEntities(msg) + '</div>'; window.scrollTo(0, document.body.scrollHeight); }\
     function addAction(nick, msg) { document.body.innerHTML += '<div><strong><span style=\"font-size: 24; vertical-align: middle; position:relative;\">•</span> ' + htmlEntities(nick) + '</strong> ' + htmlEntities(msg) + '</div>'; window.scrollTo(0, document.body.scrollHeight); }\
     </script><body style=\"word-wrap: break-word; background-color: #FFFFFF;\"><center>ShadowChat beta</center></body></html>" baseURL:[NSURL URLWithString:@"http://zomg.com"]];  //dae0ec
    //[[self view] setBackgroundColor:];
    NSLog(@"lolwat, %@", [output stringByEvaluatingJavaScriptFromString:@"return document.bgColor"]);
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
    // (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidAppear:(BOOL)animated
{
    [tfield becomeFirstResponder];
}

@end
