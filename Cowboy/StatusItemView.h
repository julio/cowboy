@interface StatusItemView : NSView {
@private
    NSImage *_image1;
    NSImage *_image2;
    NSImage *_image3;
    NSImage *_image;
    NSImage *_alternateImage;
    NSStatusItem *_statusItem;
    BOOL _isHighlighted;
    BOOL _isGood;
    BOOL _isBad;
    BOOL _isUgly;
    SEL _action;
    __unsafe_unretained id _target;
}

- (id)initWithStatusItem:(NSStatusItem *)statusItem;
- (void)redrawIcon;

@property (nonatomic, strong, readonly) NSStatusItem *statusItem;
@property (nonatomic, strong) NSImage *image;
@property (nonatomic, strong) NSImage *image1;
@property (nonatomic, strong) NSImage *image2;
@property (nonatomic, strong) NSImage *image3;
@property (nonatomic, strong) NSImage *alternateImage;
@property (nonatomic, setter = setHighlighted:) BOOL isHighlighted;
@property (nonatomic, setter = setGood:) BOOL isGood;
@property (nonatomic, setter = setBad:) BOOL isBad;
@property (nonatomic, setter = setUgly:) BOOL isUgly;
@property (nonatomic, readonly) NSRect globalRect;
@property (nonatomic) SEL action;
@property (nonatomic, unsafe_unretained) id target;

@end
