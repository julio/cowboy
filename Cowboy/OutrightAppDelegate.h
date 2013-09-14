#import <Cocoa/Cocoa.h>
#import "MenubarController.h"
#import "PanelController.h"
#import "AFNetworking.h"

@interface OutrightAppDelegate : NSObject <NSApplicationDelegate, PanelControllerDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (nonatomic, strong) MenubarController *menubarController;
@property (nonatomic, strong, readonly) PanelController *panelController;

- (IBAction)togglePanel:(id)sender;

@end
