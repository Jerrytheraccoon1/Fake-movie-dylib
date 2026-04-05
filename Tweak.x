#import <UIKit/UIKit.h>

@interface FakeMovieView : UIView <UITextFieldDelegate>
@property (nonatomic, strong) UITextField *codeField;
@end

@implementation FakeMovieView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.tag = 12345;
        self.userInteractionEnabled = YES;

        // "Movie App" Title
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, frame.size.width, 60)];
        title.text = @"CineStream Pro";
        title.font = [UIFont boldSystemFontOfSize:34];
        title.textColor = [UIColor whiteColor];
        title.textAlignment = NSTextAlignmentCenter;
        [self addSubview:title];

        // Code Entry
        _codeField = [[UITextField alloc] initWithFrame:CGRectMake((frame.size.width-220)/2, 300, 220, 50)];
        _codeField.placeholder = @"Enter Invite Code";
        _codeField.backgroundColor = [UIColor whiteColor];
        _codeField.keyboardType = UIKeyboardTypeNumberPad;
        _codeField.layer.cornerRadius = 12;
        _codeField.textAlignment = NSTextAlignmentCenter;
        _codeField.delegate = self;
        _codeField.secureTextEntry = NO; // Keep it plain so you can see what you type
        [self addSubview:_codeField];
    }
    return self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    // NEW CODE: 1024
    if ([newString isEqualToString:@"1024"]) {
        [textField resignFirstResponder]; // Hide keyboard
        [UIView animateWithDuration:0.6 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.alpha = 0;
            self.transform = CGAffineTransformMakeScale(1.1, 1.1); // Slight zoom out effect
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
    return YES;
}
@end

%hook UIWindow
- (void)makeKeyAndVisible {
    %orig;
    
    // Hooking the common Discord root controllers
    if ([self.rootViewController isKindOfClass:NSClassFromString(@"RPCanvasViewController")] || 
        [self.rootViewController isKindOfClass:NSClassFromString(@"_TtC7Discord22MainStepViewController")]) {
        
        // Prevent double-loading
        if (![self viewWithTag:12345]) {
            FakeMovieView *vault = [[FakeMovieView alloc] initWithFrame:self.bounds];
            [self addSubview:vault];
        }
    }
}
%end
