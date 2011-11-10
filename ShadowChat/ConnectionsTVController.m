//
//  ConnectionsTVController.m
//  ShadowChat
//
//  Created by James Long on 06/09/2011.
//  Copyright 2011 uiop. All rights reserved.
//

#import "ConnectionsTVController.h"
#import "AddConnectionTVController.h"
#import "SHIRCNetwork.h"
#import "SHIRCChannel.h"
#import "GradientView.h"
#import "ClearLabelsCellView.h"
@implementation ConnectionsTVController
@synthesize nothingView;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return 60;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

#pragma mark - View lifecycle
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:[self tableView]];
    [super dealloc];
}
- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:[self tableView]
                                             selector:@selector(reloadData) 
                                                 name:@"ReloadNetworks"
                                               object:nil];
    
    [super viewDidLoad];
    [self.view addSubview:nothingView];
    [nothingView setAlpha:0];
    self.title = @"Connections";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit)];
    self.navigationItem.leftBarButtonItem = rightBarButtonItem;
    [rightBarButtonItem release];
    self.tableView.allowsSelectionDuringEditing = YES;
}

- (void)edit
{
    isReallyEditing=!isReallyEditing;
    [((UITableView*)self.view) setEditing:!isReallyEditing animated:NO];
    [((UITableView*)self.view) setEditing:isReallyEditing animated:YES];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:([((UITableView*)self.view) isEditing] ? UIBarButtonSystemItemDone : UIBarButtonSystemItemEdit) target:self action:@selector(edit)];
    self.navigationItem.leftBarButtonItem = rightBarButtonItem;
    [rightBarButtonItem release];
    [((UITableView*)self.view) beginUpdates]; 
    (
     isReallyEditing ?
     [((UITableView*)self.view) insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[[SHIRCNetwork allNetworks] count] inSection:0]] withRowAnimation:UITableViewRowAnimationTop] :
     [((UITableView*)self.view) deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[[SHIRCNetwork allNetworks] count] inSection:0]] withRowAnimation:UITableViewRowAnimationTop]
    );
    [((UITableView*)self.view) endUpdates];
}

- (void)addConnection {
    NSLog(@"MUDKIPZ CONNECT! :D");
    AddConnectionTVController *addConnectionVC = [[AddConnectionTVController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *addConnectionNavController = [[UINavigationController alloc] initWithRootViewController:addConnectionVC];
    [self presentModalViewController:addConnectionNavController animated:YES];
    [addConnectionVC release];
    [addConnectionNavController release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    [self updateNoNetworks];
    return (isReallyEditing ? [[SHIRCNetwork allNetworks] count]+1 : [[SHIRCNetwork allNetworks] count]);
}

- (int)updateNoNetworks
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5f];
    if(([[SHIRCNetwork allNetworks] count]!=0)||isReallyEditing)
        [nothingView setAlpha:0];
    else
        [nothingView setAlpha:1];
    [UIView commitAnimations];
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[ClearLabelsCellView alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		cell.backgroundView = [[[GradientView alloc] initWithFrame:CGRectZero  reversed: NO] autorelease];
    }
    if ([[SHIRCNetwork allNetworks] count]==indexPath.row) {
        cell.textLabel.text = @"Add an IRC Network";
        cell.detailTextLabel.text = @"Click here to configure a new network";
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        return cell;
    }
    cell.textLabel.text=[[[SHIRCNetwork allNetworks] objectAtIndex:indexPath.row] descr] ? [[[SHIRCNetwork allNetworks] objectAtIndex:indexPath.row] descr] : [[[SHIRCNetwork allNetworks] objectAtIndex:indexPath.row] server];
    if ([[[SHIRCNetwork allNetworks] objectAtIndex:indexPath.row] isRegistered])
    {
        cell.detailTextLabel.text = @"Connected!";
    } else if ([[[[SHIRCNetwork allNetworks] objectAtIndex:indexPath.row] socket] status] == SHSocketStausError)
    {
        cell.detailTextLabel.text =@"Error connecting to the server";
    } else 
    {
        cell.detailTextLabel.text = [[[SHIRCNetwork allNetworks] objectAtIndex:indexPath.row] isOpen] ? @"Connecting..." : @"Disconnected.";
    }
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[SHIRCNetwork allNetworks] count]==indexPath.row) {
        return UITableViewCellEditingStyleInsert;
    }
    return UITableViewCellEditingStyleDelete;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [[[SHIRCNetwork allNetworks] objectAtIndex:indexPath.row] disconnect];
        [((NSMutableArray *)[SHIRCNetwork allNetworks]) removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [SHIRCNetwork saveDefaults];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        [self addConnection];
        [self performSelector:@selector(edit)];
    }
}


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate
- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)path
{
    // Determine if row is selectable based on the NSIndexPath.
    NSLog(@"OMFG, %@", path);
    if (![tv isEditing]) {
        return path;
    } else
    if ([[SHIRCNetwork allNetworks] count]==path.row)
    {
        return path;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[SHIRCNetwork allNetworks] count]==indexPath.row) {
        goto addNetwork;
    }
    if([[[SHIRCNetwork allNetworks] objectAtIndex:indexPath.row] isOpen])
         [[[SHIRCNetwork allNetworks] objectAtIndex:indexPath.row] disconnect];
    else [[[SHIRCNetwork allNetworks] objectAtIndex:indexPath.row] connect];
    goto end;
addNetwork:
    [self addConnection];
    [self performSelector:@selector(edit)];
end:
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView reloadData];
}

@end
