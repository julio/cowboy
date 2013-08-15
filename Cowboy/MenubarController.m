#import "MenubarController.h"
#import "StatusItemView.h"
#import "HTTPClient.h"

@implementation MenubarController

@synthesize statusItemView = _statusItemView;

#pragma mark -

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        // Install status item into the menu bar
        NSStatusItem *statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:STATUS_ITEM_VIEW_WIDTH];
        _statusItemView = [[StatusItemView alloc] initWithStatusItem:statusItem];
        _statusItemView.image = [NSImage imageNamed:@"icon-green"];
        _statusItemView.alternateImage = [NSImage imageNamed:@"icon-red"];
        _statusItemView.action = @selector(togglePanel:);
        
        [self updateStats];
    }
    return self;
}

- (void)dealloc
{
    [[NSStatusBar systemStatusBar] removeStatusItem:self.statusItem];
}

#pragma mark -
#pragma mark Public accessors

- (NSStatusItem *)statusItem
{
    return self.statusItemView.statusItem;
}

#pragma mark -

- (BOOL)hasActiveIcon
{
    return self.statusItemView.isHighlighted;
}

- (void)setHasActiveIcon:(BOOL)flag
{
    self.statusItemView.isHighlighted = flag;
}

- (void)updateStats
{
    [[HTTPClient sharedClient] setUsername:@"andrew.katz@outright.com" andPassword:@"1234"];
    
    [[HTTPClient sharedClient] getPath:@"/admin/importer_progress" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        int importerLevel = [[[responseObject objectForKey:@"importer_status"] objectForKey:@"level"] intValue];
        BOOL importerStatus = importerLevel == 1;
        
        NSLog(@"%d", importerLevel);
        [self setHasActiveIcon:importerStatus];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // error stuff here
        NSLog(@"error: %@", error);
    }];
}

@end
