#import "OutrightAppDelegate.h"
#import "HTTPClient.h"

@implementation OutrightAppDelegate

@synthesize panelController = _panelController;
@synthesize menubarController = _menubarController;
@synthesize window;

#pragma mark -

- (void)dealloc
{
  [_panelController removeObserver:self forKeyPath:@"hasActivePanel"];
}

#pragma mark -

void *kContextActivePanel = &kContextActivePanel;

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  if (context == kContextActivePanel) {
    self.menubarController.hasActiveIcon = self.panelController.hasActivePanel;
  }
  else {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
}

#pragma mark - NSApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
  // Install icon into the menu bar
  self.menubarController = [[MenubarController alloc] init];
  

    [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(refresh) userInfo:nil repeats:YES];
}

- (void)refresh
{
    NSURL *url = [NSURL URLWithString:@"https://secure.outright.com/admin/importer_alerts/current"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        //NSLog(@"IP Address: %@", [JSON valueForKeyPath:@"origin"]);
        NSLog(@"%@", [JSON valueForKey:@"level"]);
    } failure:nil];
    
    [operation start];
    
    
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
  // Explicitly remove the icon from the menu bar
  self.menubarController = nil;
  return NSTerminateNow;
}

#pragma mark - Actions

- (IBAction)togglePanel:(id)sender
{
  self.panelController.hasActivePanel = !self.panelController.hasActivePanel;
}

#pragma mark - Public accessors

- (PanelController *)panelController
{
  if (_panelController == nil) {
    _panelController = [[PanelController alloc] initWithDelegate:self];
    [_panelController addObserver:self forKeyPath:@"hasActivePanel" options:0 context:kContextActivePanel];
  }
  return _panelController;
}

#pragma mark - PanelControllerDelegate

- (StatusItemView *)statusItemViewForPanelController:(PanelController *)controller
{
  return self.menubarController.statusItemView;
}

@end
