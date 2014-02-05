//
//  NSTextFieldMask.m
//  textFieldFormatter
//
//  Created by Andrii Tishchenko on 03.02.14.
//  Copyright (c) 2014 Andrii Tishchenko. All rights reserved.
//

#import "NSTextFieldMask.h"
#define NSTextFieldMaskFormatMaskColor [UIColor lightGrayColor]
#define NSTextFieldMaskFormatTextColor [UIColor blackColor]

@interface NSTextFieldMask()
    @property (nonatomic,strong) NSMutableArray*formatMaskArray;
    @property (nonatomic,strong) NSMutableArray*valueMaskArray;
    @property (nonatomic, strong) UIColor*tmpTextColor;

    -(void)setFormatMask:(NSString*)mask;
@end


@implementation NSTextFieldMask
@synthesize maskPlaceholderSymbolNumber=_maskPlaceholderSymbolNumber;
@synthesize maskPlaceholderSymbolAlpha=_maskPlaceholderSymbolAlpha;
@synthesize placeholder=_placeholder;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setDefaults];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self setDefaults];
    }
    return self;
}

-(id)init
{
    self = [super init];
    if(self)
    {
        //[self setDefaults];
    }
    return self;
}
////[self.MyTextField setValue:[UIColor darkGrayColor] forKeyPath:@"_placeholderLabel.textColor"];


- (void)setMaskPlaceholderSymbolNumber:(NSString *)value {
    _maskPlaceholderSymbolNumber = [value substringWithRange:NSMakeRange(0,1)];
//    [self displayText];
}
- (NSString*)maskPlaceholderSymbolNumber {
    return _maskPlaceholderSymbolNumber;
}

- (void)setMaskPlaceholderSymbolAlpha:(NSString *)value {
    _maskPlaceholderSymbolAlpha = [value substringWithRange:NSMakeRange(0,1)];
//    [self displayText];
}
- (NSString*)maskPlaceholderSymbolAlpha {
    return _maskPlaceholderSymbolAlpha;
}

- (void)setPlaceholder:(NSString *)value {
    _placeholder = [value copy];
    [self setFormatMask:_placeholder];
}
- (NSString*)placeholder {
    return _placeholder;
}


-(void)readIBValues
{
    if ([self valueForKeyPath:@"maskPlaceholderSymbolNumber"]) {
        NSString*vl = [self valueForKeyPath:@"maskPlaceholderSymbolNumber"];
        if (vl) {
            self.maskPlaceholderSymbolNumber =vl;
        }
    }
    
    if ([self valueForKeyPath:@"maskPlaceholderSymbolAlpha"]) {
        NSString*vl = [self valueForKeyPath:@"maskPlaceholderSymbolAlpha"];
        if (vl) {
            self.maskPlaceholderSymbolAlpha =vl;
        }
    }
    
    if ([self valueForKeyPath:@"maskPlaceholderColor"]) {
        UIColor*vl = [self valueForKeyPath:@"maskPlaceholderColor"];
        if (vl) {
            self.maskPlaceholderColor =vl;
        }
    }
    
    
    if ([self valueForKeyPath:@"textColor"]) {
        UIColor*vl = [self valueForKeyPath:@"textColor"];
        if (vl) {
            self.tmpTextColor =vl;
        }
    }
    
    if ([self valueForKeyPath:@"_placeholderLabel.text"]) {
        NSString*vl = [self valueForKeyPath:@"_placeholderLabel.text"];
        if (vl) {
            [self setFormatMask:vl];
        }
    }
}

-(void)setDefaults{
    [self setDelegate:self];
    if(!self.formatMaskArray)  self.formatMaskArray = [NSMutableArray new];
    if(!self.valueMaskArray)   self.valueMaskArray =[NSMutableArray new] ;
    
    self.maskPlaceholderSymbolNumber = @"#";
    self.maskPlaceholderSymbolAlpha = @"@";
    self.maskPlaceholderColor = NSTextFieldMaskFormatMaskColor;
    self.tmpTextColor = NSTextFieldMaskFormatTextColor;
    
    [self readIBValues];

    [self addObserver:self
           forKeyPath:@"textColor"
              options:(NSKeyValueObservingOptionNew)
              context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if ([keyPath isEqual:@"textColor"]) {
        UIColor*vl = [change objectForKey:NSKeyValueChangeNewKey];
        if(vl){
            self.tmpTextColor = vl;
        }else
        {
            self.tmpTextColor = NSTextFieldMaskFormatMaskColor;
        }
    }
    else{
        [super observeValueForKeyPath:keyPath ofObject:object
                               change:change context:context];
    }
}

-(BOOL)validate{
    __block BOOL rez =  YES;
    if ([self.formatMaskArray count]>0) {
        [self.valueMaskArray enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL *stop) {
            if ([obj isEqualToString:@""]) {
                *stop = YES;
                rez = NO;
            }
        }];
    }
    return rez;
}

-(void)clearEvent
{
    NSString * formatString = [self.formatMaskArray componentsJoinedByString:@""];
    [self setFormatMask:formatString];
}


-(NSString*)getFormatedText
{
    if (!self.formatMaskArray || [self.formatMaskArray count]==0) {
        return nil;
    }
    NSMutableArray*showArray= [[NSMutableArray alloc] initWithArray:self.valueMaskArray];
    
    for (int i=0; i < [showArray count]; i++) {
        NSString *ichar  = [showArray objectAtIndex:i];
        if ([ichar isEqualToString:@""]) {
            NSString*c = [self.formatMaskArray[i] copy];
            if ([c isEqualToString:@"#"]) {
                [showArray replaceObjectAtIndex:i withObject:[self.maskPlaceholderSymbolNumber copy]];
            }
            else if ([c isEqualToString:@"~"]) {
                [showArray replaceObjectAtIndex:i withObject:[self.maskPlaceholderSymbolAlpha copy]];
            }
            else
                [showArray replaceObjectAtIndex:i withObject:c];
        }
    }
    
    NSString * joinedString = [showArray componentsJoinedByString:@""];
    
    return joinedString;
}

-(NSMutableAttributedString*)getFormatedAttributedString
{
    NSString*textToShow = [self getFormatedText];
    if (textToShow == nil) {
        return nil;
    }
//    if (self.tmpTextColor) {
//        self.textColor = self.tmpTextColor;
//    }
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:textToShow];
    for (int i=0; i<[self.formatMaskArray count];i++) {
        NSString *ichar  = [self.formatMaskArray objectAtIndex:i];
        if ([self isPlaceholderChar:ichar] && [self.valueMaskArray[i] isEqualToString:@""]) {
            [string addAttribute:NSForegroundColorAttributeName value:self.maskPlaceholderColor range:NSMakeRange(i,1)];
        }
        else
        {
            [string addAttribute:NSForegroundColorAttributeName value:self.tmpTextColor range:NSMakeRange(i,1)];
        }
    }
    
    return string;
}



-(void)setFormatMask:(NSString*)mask
{
    [self.formatMaskArray removeAllObjects];
    [self.valueMaskArray removeAllObjects];
    if (!mask || mask==[NSNull null]) {
        [self displayText];
        return;
    }
    self.formatMaskArray = [[NSMutableArray alloc] initWithCapacity:[mask length]];
    self.valueMaskArray = [[NSMutableArray alloc] initWithCapacity:[mask length]];
    for (int i=0; i < [mask length]; i++) {
        NSRange rng = {i, 1};
        NSString *ichar  = [mask substringWithRange:rng];
        [self.formatMaskArray addObject:ichar];
        if ([self isPlaceholderChar:ichar]==NO) {
            [self.valueMaskArray addObject:ichar];
        }
        else
        {
            [self.valueMaskArray addObject:@""];
        }
    }
    
    [self displayText];
}

-(BOOL)isPlaceholderChar:(NSString*)str
{
    if ([str isEqualToString:@"#"] ||
        [str isEqualToString:@"~"])
    {
        return YES;
    }
    return NO;
}


-(void)setCursorToPosition:(NSInteger)position
{
    UITextPosition *newCursorPosition = [self positionFromPosition:self.beginningOfDocument offset:position];
    UITextRange *newSelectedRange = [self textRangeFromPosition:newCursorPosition toPosition:newCursorPosition];
    [self setSelectedTextRange:newSelectedRange];
}

-(void)displayText
{
//    NSString*text = [self getFormatedText];
    NSAttributedString*str = [self getFormatedAttributedString];
    if (str) {
        self.attributedText = str;
//        self.attributedPlaceholder = str;
    }
    else
        self.text =@"";
    
}

-(void)drawRect:(CGRect)rect
{
    [self displayText];
}

-(void)updateWithPosition:(NSInteger)pos
{
    [self displayText];
    [self setCursorToPosition:pos];
}



-(NSInteger)getNextIndexAfter:(NSInteger)position
{
   __block  NSInteger rez = position;
    [self.formatMaskArray enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL *stop) {
        if (position<=idx &&[self isPlaceholderChar:obj]) {
            *stop = YES;
            rez = idx;
        }
    }];
    
    return rez;
}

-(NSInteger)getLastIndexWithFiledItem:(BOOL)status
{
    NSInteger rez = -1;
    NSInteger findex = -1;
    for (int i=[self.formatMaskArray count]-1; i >= 0; i--) {
        NSString*f = self.formatMaskArray[i];
        NSString*v = self.valueMaskArray[i];

        if ([self isPlaceholderChar:f]){
            findex = i;
            
         if([v isEqualToString:@""]!=status) {
            rez=i;
            break;
         }
            
        }
    }
    if(rez==-1)
    {
            rez = findex;
    }
    
    return rez;
}

-(NSInteger)getFirstIndexWithFiledItem:(BOOL)status
{
    NSInteger rez = -1;
    NSInteger findex = -1;
    if ([self.formatMaskArray count]>0) {
        for (int i=0; i <= [self.formatMaskArray count]-1; i++) {
            NSString*f = self.formatMaskArray[i];
            NSString*v = self.valueMaskArray[i];
            
            if ([self isPlaceholderChar:f]){
                findex = i;
                
                if([v isEqualToString:@""]!=status) {
                    rez=i;
                    break;
                }
                
            }
        }
        
    }
    if(rez==-1)
    {
        rez = findex;
    }
    
    return rez;
}

#pragma  mark - UITextView delegates

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString*preModifyString = string;
    if (self.mask_delegate) {
        if ([self.mask_delegate respondsToSelector:@selector(textFieldMask:willProcessWithCharacter:inRange:)]) {
           preModifyString = [self.mask_delegate textFieldMask:self willProcessWithCharacter:string inRange:range];
            if (preModifyString == nil) {
                return NO;
            }
        }
    }

    NSInteger newPos = range.location;
    NSInteger emptyIndex =0;
    NSInteger formatCount = [self.formatMaskArray count];
    
    if (formatCount ==0) {
        return YES;
    }
    if (range.location >= formatCount) {
        return NO;
    }
    
    if (range.length>0) { //backspase clicked
        //set cursor to the end of text and remove last requaried symbol
        emptyIndex = [self getLastIndexWithFiledItem:YES];
        
        [self.valueMaskArray replaceObjectAtIndex:emptyIndex withObject:@""];
        
        NSInteger pos = [self getFirstIndexWithFiledItem:NO];
        [self updateWithPosition:pos];
        return NO;
    }
    else
    {
        emptyIndex = [self getNextIndexAfter:newPos];
    }
   
    NSString*charAtRange = [self.formatMaskArray objectAtIndex:emptyIndex];
    
    NSCharacterSet *letterSet = [NSCharacterSet letterCharacterSet];
    const unichar c = [preModifyString characterAtIndex:0];
    BOOL isAlpha = [letterSet characterIsMember:c];
    BOOL isDigit =isdigit(c)?YES:NO;
    NSString*curSymbol = [NSString stringWithCharacters:&c length:1];
    
    if ([charAtRange isEqualToString:@"#"] && isDigit==YES) {
        [self.valueMaskArray replaceObjectAtIndex:emptyIndex withObject:curSymbol];
        newPos++;
    }
    else if ([charAtRange isEqualToString:@"~"] && isAlpha==YES) {
        [self.valueMaskArray replaceObjectAtIndex:emptyIndex withObject:curSymbol];
        newPos++;
    }else
    {
        if (self.mask_delegate) {
            if ([self.mask_delegate respondsToSelector:@selector(textFieldMask:wrongCharacterAtPosition:)]) {
                [self.mask_delegate textFieldMask:self wrongCharacterAtPosition:emptyIndex];
            }
        }
    }
    
    NSInteger pos = [self getNextIndexAfter:newPos];
    [self updateWithPosition:pos];
    
    if ([self validate]== YES) {
        if (self.mask_delegate) {
            if ([self.mask_delegate respondsToSelector:@selector(textFieldMask:continueWithString:)]) {
                [self.mask_delegate textFieldMask:self continueWithString:[self getFormatedText]];
            }
        }
    }
    
    return NO;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [self clearEvent];
    NSInteger pos = [self getFirstIndexWithFiledItem:NO];
    [self updateWithPosition:pos];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSInteger index = [self getLastIndexWithFiledItem:YES];
    [self setCursorToPosition:index];
    
    if (self.mask_delegate) {
        if ([self.mask_delegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
            [self.mask_delegate textFieldDidBeginEditing:self];
        }
    }
}


#pragma  mark - UITextView delegates redirect

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.mask_delegate) {
        if ([self.mask_delegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
            return [self.mask_delegate textFieldShouldReturn:self];
        }
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.mask_delegate) {
        if ([self.mask_delegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
            [self.mask_delegate textFieldDidEndEditing:self];
        }
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (self.mask_delegate) {
        if ([self.mask_delegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
            return [self.mask_delegate textFieldShouldEndEditing:self];
        }
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.mask_delegate) {
        if ([self.mask_delegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
            return [self.mask_delegate textFieldShouldBeginEditing:self];
        }
    }
    return YES;
}

-(void)dealloc
{
    [self removeObserver:self forKeyPath:@"textColor"];
//    [self removeObserver:self forKeyPath:@"placeholder"];

    self.formatMaskArray = nil;
    self.valueMaskArray = nil;
    self.maskPlaceholderColor = nil;
    self.maskPlaceholderSymbolNumber = nil;
    self.maskPlaceholderSymbolAlpha = nil;
}

@end
