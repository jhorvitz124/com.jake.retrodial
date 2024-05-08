#import <UIKit/UIKit.h>
#import <substrate.h>
#import <AudioToolbox/AudioToolbox.h>

@interface PHFavoritesCell : UITableViewCell
- (void)textFieldDidBeginEditing:(id)arg1;
@end

@interface PHFavoritesViewController : UITableViewController
- (void)textFieldDidBeginEditing:(id)arg1;
@end

@interface RetroDialView : UIView
@property (nonatomic, strong) UILabel *dialLabel;
@property (nonatomic, strong) UIImageView *dialerImageView;
@property (nonatomic, strong) UIButton *dialButton;
@property (nonatomic, strong) NSMutableString *enteredNumber;
@end

@implementation RetroDialView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _enteredNumber = [[NSMutableString alloc] init];
        
        // Add dial label
        _dialLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, frame.size.width - 40, 50)];
        _dialLabel.textAlignment = NSTextAlignmentCenter;
        _dialLabel.textColor = [UIColor whiteColor];
        _dialLabel.font = [UIFont systemFontOfSize:40];
        [self addSubview:_dialLabel];
        
        // Add dialer image view
        _dialerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 150, frame.size.width - 40, frame.size.width - 40)];
        _dialerImageView.image = [UIImage imageNamed:@"dialer"];
        [self addSubview:_dialerImageView];
        
        // Add dial button
        _dialButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _dialButton.frame = CGRectMake(frame.size.width/2 - 50, frame.size.height - 150, 100, 50);
        [_dialButton setTitle:@"Dial" forState:UIControlStateNormal];
        [_dialButton addTarget:self action:@selector(dialNumber) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_dialButton];
    }
    return self;
}

- (void)dialNumber {
    // Play dialing sound
    AudioServicesPlaySystemSound(1200);
    
    // Dial the entered number
    NSLog(@"Dialing number: %@", self.enteredNumber);
    
    // Clear entered number
    [self.enteredNumber setString:@""];
    self.dialLabel.text = @"";
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    // Calculate angle and number based on touch location
    CGFloat angle = atan2(touchPoint.y - self.dialerImageView.center.y, touchPoint.x - self.dialerImageView.center.x);
    angle = angle < 0 ? angle + (2 * M_PI) : angle;
    int number = (int)ceil(angle / (2 * M_PI) * 10);
    if (number == 10) number = 0;
    
    // Add number to entered number
    [self.enteredNumber appendString:[NSString stringWithFormat:@"%d", number]];
    self.dialLabel.text = self.enteredNumber;
}

@end

@implementation PHFavoritesCell

- (void)textFieldDidBeginEditing:(id)arg1 {
    [self showRotaryDialer];
    %orig;
}

- (void)showRotaryDialer {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    RetroDialView *dialerView = [[RetroDialView alloc] initWithFrame:window.bounds];
    dialerView.backgroundColor = [UIColor blackColor];
    [window addSubview:dialerView];
    [window bringSubviewToFront:dialerView];
}

@end

@implementation PHFavoritesViewController

- (void)textFieldDidBeginEditing:(id)arg1 {
    [self showRotaryDialer];
    %orig;
}

- (void)showRotaryDialer {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    RetroDialView *dialerView = [[RetroDialView alloc] initWithFrame:window.bounds];
    dialerView.backgroundColor = [UIColor blackColor];
    [window addSubview:dialerView];
    [window bringSubviewToFront:dialerView];
}

@end
