//
//  NSTextFieldMask.h
//  textFieldFormatter
//
//  Created by Andrii Tishchenko on 03.02.14.
//  Copyright (c) 2014 Andrii Tishchenko. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol NSTextFieldMaskDelegate;

/**
 NSTextFieldMask is a subclass of UITextField, defined in "NSTextFieldMask.h".
 It add possibility to use placeholder as mask format for input.
 Uses own protocol NSTextFieldMaskDelegate.
 Defined number symbol is '#'.
 Defined alpha symbol is '~'.
 Avalible properties for IB:
 -UIColor*maskPlaceholderColor;
 -NSString*maskPlaceholderSymbolNumber;
 -NSString*maskPlaceholderSymbolAlpha;
 -id<NSTextFieldMaskDelegate> mask_delegate;
 @param
 
 @return NSTextFieldMask* object
 */
@interface NSTextFieldMask : UITextField<UITextFieldDelegate>

    /** Color of requaried symbols (#,~). Other text uses .textColor value  */
    @property (nonatomic, strong) UIColor*maskPlaceholderColor;

    /** Replaser symbol for default Number symbol '#'  */
    @property (nonatomic) NSString*maskPlaceholderSymbolNumber;

    /** Replaser symbol for default Alpha symbol '~'  */
    @property (nonatomic) NSString*maskPlaceholderSymbolAlpha;

    /** Replaser symbol for default Alpha symbol '~'  */
    @property (assign,nonatomic) IBOutlet id<NSTextFieldMaskDelegate> mask_delegate;



/**
 
 @param
 
 @return NSString* formated value with placeholder mask
 
 */
    -(NSString*)getFormatedText;

@end

/**
 NSTextFieldMaskDelegate defined in "NSTextFieldMask.h"
 Based on UITextFieldDelegate.
 */
@protocol NSTextFieldMaskDelegate <UITextFieldDelegate>
    @optional

    /**
     Calls when textfield filled correctly
     @param textFieldMask:(NSTextFieldMask*)tf
     @param continueWithString:(NSString*)
     @return nil
     */
    -(void)textFieldMask:(NSTextFieldMask*)tf continueWithString:(NSString*)string;

    /**
     Calls before shouldChangeCharactersInRange. Allow modify input string
     @param textFieldMask:(NSTextFieldMask*)tf
     @param continueWithString:(NSString*)
     @param inRange:(NSRange)
     @return NSString*
     */
    -(NSString*)textFieldMask:(NSTextFieldMask*)tf willProcessWithCharacter:(NSString*)character inRange:(NSRange)range ;
    /**
     Calls when symbol not satisfied pattern mask
     @param textFieldMask:(NSTextFieldMask*)tf
     @param wrongCharacterAtPosition:(NSInteger)
     @return nil
     */
    -(void)textFieldMask:(NSTextFieldMask*)tf wrongCharacterAtPosition:(NSInteger)position;
@end