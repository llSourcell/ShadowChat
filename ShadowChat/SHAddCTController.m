
//
//  AddConnectionTVController.m
//  ShadowChat
//
//  Created by James Long on 06/09/2011.
//  Copyright 2011 uiop. All rights reserved.
//

#import "SHAddCTController.h"

#import "SHIRCChannel.h"
@interface UIView (FindAndResignFirstResponder)
- (BOOL)findAndResignFirstResponder;
@end
@implementation UIView (FindAndResignFirstResponder)

- (BOOL)findAndResignFirstResponder {
    if (self.isFirstResponder) {
        [self resignFirstResponder];
        return YES;     
    }
    for (UIView *subView in self.subviews) {
        if ([subView findAndResignFirstResponder])
            return YES;
    }
    return NO;
}
@end

@implementation SHAddCTController

- (id)initWithStyle:(UITableViewStyle)style andNetwork:(SHIRCNetwork *)net {
	if ((self = [super initWithStyle:style])) {
		_network = net;
		NSLog(@"Network %@ %@", net, _network);
		hasSSL = _network.hasSSL;
        description = nil;
        server = nil;
        user = nil;
        nick = nil;
        name = nil;
        spass = nil;
        npass = nil;
        hasSSL = NO;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"ffuuuuu %@ %@", self.parentViewController, [self navigationController].parentViewController);
    self.title = @"Add Connection";

    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneConnection)];
	existingConnection = !(!_network);
	rightBarButtonItem.enabled = existingConnection;
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    [rightBarButtonItem release];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelConnection)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    [leftBarButtonItem release];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;

}

- (void)doneConnection {
    NSLog(@"Done :D");
    [[self tableView] findAndResignFirstResponder];
	if (existingConnection) {
		[_network disconnect];
		NSLog(@"heh. %@", _network);
		if (description.text) 
			_network.descr = description.text;
		if (server.text)
			_network.server = server.text;
		if (user.text)
			_network.username = user.text;
		if (nick.text)
			_network.nickname = nick.text;
		if (name.text)
			_network.realname = name.text;
		if (spass.text)
			_network.serverPassword = spass.text;
		if (npass.text) 
			_network.nickServPassword = npass.text;
		if (port.text)
			_network.port = [port.text intValue];
		if (_network.hasSSL != hasSSL)
			_network.hasSSL = hasSSL;
		[_network saveDefaults];
		[_network connect];
	}
	else {
		[[SHIRCNetwork createNetworkWithServer:[server text] andPort:([[port text] intValue] == 0 ? 6667 : [[port text] intValue]) isSSLEnabled:hasSSL description:[description text]
								  withUsername:user ? [user text] : @"shadowchat"
								   andNickname:nick ? [nick text] : [[[[UIDevice currentDevice] name] componentsSeparatedByString:@" "] objectAtIndex:0]
								   andRealname:name ? [name text] : @"ShadowChat User"
								serverPassword:[spass text]
							  nickServPassword:[npass text]]
		 connect];
	}
    [self dismissModalViewControllerAnimated:YES];
}

- (void)cancelConnection {
    NSLog(@"Cancelled D:");
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 4;
        case 1:
            return 3;
        case 2:
            return 2;
        default:
            return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"Connection Information";
        case 1:
            return @"User Information";
        case 2:
            return @"Authentication";
        default:
            return nil;
    }
	return @"Whaaa?! :'(";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [[NSString alloc] initWithFormat:@"serverconnection-%d-%d", indexPath.section, indexPath.row];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                switch (indexPath.section) {
            case 0:
                if (indexPath.row == 0) {                
                    [cell.textLabel setText: @"Description"];
                    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
                    UITextField *adescr = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 180, 22)];
                    adescr.adjustsFontSizeToFitWidth = YES;
                    adescr.placeholder = @"Enter a description";
					adescr.text = _network.descr;
                    adescr.returnKeyType = UIReturnKeyNext;
                    adescr.tag = 12340;
                    adescr.keyboardAppearance = UIKeyboardAppearanceAlert;
                    [adescr setDelegate:self];
                    [cell setAccessoryView: adescr];
                    [adescr release];
                }
				else if (indexPath.row == 1) {
                    [cell.textLabel setText: @"Address"];
                    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
                    UITextField *aaddr = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 180, 22)];
                    aaddr.adjustsFontSizeToFitWidth = YES;
                    aaddr.placeholder = @"irc.network.tld";
                    aaddr.keyboardType = UIKeyboardTypeURL;
					aaddr.text = _network.server;
                    aaddr.returnKeyType = UIReturnKeyNext;
                    aaddr.tag = 12341;
                    aaddr.keyboardAppearance = UIKeyboardAppearanceAlert;
                    [aaddr setDelegate:self];
                    [cell setAccessoryView: aaddr];
                    [aaddr release];
                }
				else if (indexPath.row == 2) {
                    [cell.textLabel setText: @"Port"];
                    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
                    UITextField *portField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 180, 22)];
                    portField.adjustsFontSizeToFitWidth = YES;
                    portField.placeholder = @"6667";
                    portField.keyboardType = UIKeyboardTypeNumberPad;
                    portField.returnKeyType = UIReturnKeyNext;
                    portField.tag = 12342;
					portField.text = (_network.port == 0 ? nil : [NSString stringWithFormat:@"%d", _network.port]);
                    portField.keyboardAppearance = UIKeyboardAppearanceAlert;
                    [portField setDelegate:self];
                    [cell setAccessoryView: portField];
                    [portField release];
                }
				else if (indexPath.row == 3) {
                    [cell.textLabel setText: @"Connect via SSL"];
                    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
                    UISwitch *sslSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
                    sslSwitch.tag = 12350;
                    [sslSwitch addTarget: self action: @selector(flip:) forControlEvents:UIControlEventValueChanged];
                    [cell setAccessoryView:sslSwitch];
					[sslSwitch setOn:hasSSL];
                    [sslSwitch release];
                }
                break;
            case 1:
                if (indexPath.row == 0) {                
                    [cell.textLabel setText: @"Username"];
                    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
                    UITextField *userField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 180, 22)];
                    userField.adjustsFontSizeToFitWidth = YES;
                    userField.placeholder = @"shadowchat";
                    userField.returnKeyType = UIReturnKeyNext;
                    userField.keyboardAppearance = UIKeyboardAppearanceAlert;
					userField.tag = 12343;
					userField.text = _network.username;
                    [userField setDelegate:self];
                    [cell setAccessoryView: userField];
                    [userField release];
                } else if (indexPath.row == 1) {
                    [cell.textLabel setText: @"Nickname"];
                    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
                    UITextField *nickField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 180, 22)];
                    nickField.adjustsFontSizeToFitWidth = YES;
                    nickField.keyboardAppearance = UIKeyboardAppearanceAlert;
                    @try {
                        nickField.placeholder = [[[[UIDevice currentDevice] name] componentsSeparatedByString:@" "] objectAtIndex:0];
                    }
                    @catch (NSException *exception) {
                        nickField.placeholder = @"James";
                    }
                    nickField.returnKeyType = UIReturnKeyNext;
					nickField.text = _network.nickname;;
                    nickField.tag = 12344;
                    [nickField setDelegate:self];
                    [cell setAccessoryView: nickField];
                    [nickField release];
                } else if (indexPath.row == 2) {
                    [cell.textLabel setText: @"Real Name"];
                    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];

                    UITextField *rlname = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 180, 22)];
                    rlname.adjustsFontSizeToFitWidth = YES;
                    rlname.keyboardAppearance = UIKeyboardAppearanceAlert;
                    rlname.placeholder = @"ShadowChat User";
					rlname.text = _network.realname;
                    rlname.returnKeyType = UIReturnKeyNext;
                    rlname.tag = 12345;
                    [rlname setDelegate:self];
                    [cell setAccessoryView: rlname];
                    [rlname release];
                }
                break;
            case 2:
                if (indexPath.row == 0) {                
                    [cell.textLabel setText: @"Nick Password"];
                    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
                    
                    UITextField *passField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 155, 22)];
                    passField.adjustsFontSizeToFitWidth = YES;
                    passField.placeholder = @"";
                    passField.returnKeyType = UIReturnKeyNext;
                    passField.keyboardAppearance = UIKeyboardAppearanceAlert;
                    passField.secureTextEntry = YES;
                    passField.tag = 12346;
					passField.text = _network.nickServPassword;
                    [passField setDelegate:self];
                    [cell setAccessoryView: passField];
                    [passField release];
                }
				else if (indexPath.row == 1) {
                    [cell.textLabel setText: @"Server password"];
                    cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
                    UITextField *nserv = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 155, 22)];
                    nserv.keyboardAppearance = UIKeyboardAppearanceAlert;
                    nserv.adjustsFontSizeToFitWidth = YES;
                    nserv.placeholder = @"";
					nserv.text = _network.serverPassword;
                    nserv.returnKeyType = UIReturnKeyDone;
                    nserv.tag = 12347;
                    [nserv setDelegate:self];
                    [cell setAccessoryView: nserv];
                    [nserv release];
                } 
                break;
            default:
                break;
        }
    }
    cell.tag = 1227;
    [CellIdentifier release];
    return cell;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField tag] == 12341 || [textField tag] == 12344 || [textField tag] == 12343) {
        if ([string isEqualToString:@" "]) {
            return NO;
        }
        if ([textField tag] == 12341) {
            if (range.length==1 && [[textField text] length] == 1) {
                self.navigationItem.rightBarButtonItem.enabled = NO;
            } 
			else if (range.length == 0 && range.location == 0) {
                self.navigationItem.rightBarButtonItem.enabled = YES;
            }
        }
    }
    return YES;
}
- (void)flip:(id)sender {
    hasSSL = [sender isOn];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [[[self tableView] viewWithTag:textField.tag+1] becomeFirstResponder];
    [[self tableView] scrollToRowAtIndexPath:[self.tableView indexPathForCell:(UITableViewCell *)
                                              [textField superview]] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    return NO;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    switch ([textField tag]) {
        case 12340: // Description 
            description = textField;
            break;
        case 12341: // Server
            server = textField;
            break;
        case 12342: // Port
			port = textField;
            break;
        case 12343: // User name
            user = (![[textField text] isEqualToString:@""]) ? textField : nil;
            break;
        case 12344: // Nick name
            nick = (![[textField text] isEqualToString:@""]) ? textField : nil;
            break;
        case 12345: // Real Name
            name = (![[textField text] isEqualToString:@""]) ? textField : nil;
            break;
        case 12346: // Nickserv pass
            npass = textField;
            break;
        case 12347: // Server Pass
            spass = textField;
            break;
        default:
            break;
    }
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}
- (void) dealloc {
    NSLog(@"Deallocating");
    
    [super dealloc];
}

@end
