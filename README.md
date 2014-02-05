TESTED NOT ENOUGH
===============


NSTextFieldMask
===============
Allow use placeholder as mask pattern


Mask rules
===============
'~' means alpha
'#' means digit
Its possible combine it any way you like


Usage
===============
#import "NSTextFieldMask.h"
add <NSTextFieldMaskDelegate> to controller

manualy:
create UIObject

    NSTextFieldMask*tf = [[NSTextFieldMask alloc] initWithFrame:CGRectMake(20, 340, 400, 40)];
    tf.mask_delegate = self; //require
    tf.maskPlaceholderColor = [UIColor greenColor];
    tf.textColor = [UIColor redColor];
    tf.maskPlaceholderSymbolAlpha = @"+";
    tf.maskPlaceholderSymbolNumber = @"%";
    tf.placeholder = @"NUM:### ALPHA:~~~"; //require
    [self.view addSubview:tf];
IB

1 add UITextField
2 set class as NSTextFieldMask
3 set .mask_delegate to controller
4 go to Runtime attributes and customize
- maskPlaceholderColor
- maskPlaceholderSymbolNumber
- maskPlaceholderSymbolAlpha

  
