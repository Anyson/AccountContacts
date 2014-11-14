//
//  ContactHandler.m
//  AccountContacts
//
//  Created by Anyson Chan on 14/11/14.
//  Copyright (c) 2014年 Sachsen. All rights reserved.
//

@import AddressBook;
#import "ContactHandler.h"

//电话格式(多个号码用|隔开) iPhone:18620399163:China:联通:深圳|mobile:18118733502:China:电信:深圳

#define PHOTO           @"Photo"//0 or 1 有为1,没有为0
#define LAST_NAME       @"Last"
#define MIDDLE_NAME     @"Middle"
#define FIRST_NAME      @"First"
#define COMPANY         @"Company"
#define NICKNAME        @"Nickname"
#define EMAIL           @"Email"//0 or 1
#define RINGTONE        @"Ringtone"//0 or 1
#define VIBRATION       @"Vibration"//0 or 1
#define SMS_TONE        @"SMS tone"//0 or 1
#define SMS_VIBRATION   @"SMS Vibration"//0 or 1
#define URL             @"URL"//0 or 1
#define ADDRESS         @"address" //0 or 1
#define BIRTHDAY        @"birthday"//0 or 1
#define DATE            @"date"//0 or 1
#define RELATED_NAME    @"related name"//0 or 1
#define SOCIAL_PROFILE  @"social profile"//0 or 1
#define INSTANT_MESSAGE @"instant message"//0 or 1

@interface ContactHandler () {
    ABAddressBookRef myAddressBook;
}

@property (nonatomic, strong) NSMutableArray *recordArray;

@end

@implementation ContactHandler

- (instancetype)init
{
    self = [super init];
    if (self) {
        CFErrorRef myError = nil;
        myAddressBook = ABAddressBookCreateWithOptions(nil, &myError);
        if (myError) {
            NSLog(@"create ABAddressBook error");
            CFRelease(myError);
        }
        
        _recordArray = [NSMutableArray array];
    }
    return self;
}

- (void)gainAllContactPerson {
    ABAddressBookRequestAccessWithCompletion(myAddressBook, ^(bool granted, CFErrorRef error) {
        if (granted) {
            NSArray *personList = CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(myAddressBook));
            NSMutableString *recordStr;
            for (id personId in personList) {
                recordStr = [NSMutableString stringWithString:@""];
                ABRecordRef personRef = (__bridge ABRecordRef)personId;
                [recordStr appendFormat:@"%@:%d;", PHOTO, ABPersonHasImageData(personRef) ? 1 : 0];
                
                NSString *lastName = CFBridgingRelease(ABRecordCopyValue(personRef, kABPersonLastNameProperty));
                if (lastName && ![lastName isEqualToString:@""]) {
                    [recordStr appendFormat:@"%@:%@;", LAST_NAME, lastName];
                }
                
                NSString *middleName = CFBridgingRelease(ABRecordCopyValue(personRef, kABPersonMiddleNameProperty));
                if (middleName && ![middleName isEqualToString:@""]) {
                    [recordStr appendFormat:@"%@:%@;", MIDDLE_NAME, middleName];
                }
                
                NSString *firstName = CFBridgingRelease(ABRecordCopyValue(personRef, kABPersonFirstNameProperty));
                if (firstName && ![firstName isEqualToString:@""]) {
                    [recordStr appendFormat:@"%@:%@;", FIRST_NAME, firstName];
                }
                
                NSString *company = CFBridgingRelease(ABRecordCopyValue(personRef, kABPersonOrganizationProperty));
                if (company && ![company isEqualToString:@""]) {
                    [recordStr appendFormat:@"%@:%@;", COMPANY, company];
                }
                
                NSString *nickname = CFBridgingRelease(ABRecordCopyValue(personRef, kABPersonNicknameProperty));
                if (nickname && ![nickname isEqualToString:@""]) {
                    [recordStr appendFormat:@"%@:%@;", NICKNAME, nickname];
                }
                
                /*****************
                 * TODO 电话分析
                 ****************/
                ABMultiValueRef phones = ABRecordCopyValue(personRef, kABPersonPhoneProperty);
                NSArray *phoneArray = CFBridgingRelease(ABMultiValueCopyArrayOfAllValues(phones));
                
                NSString *email = CFBridgingRelease(ABRecordCopyValue(personRef, kABPersonEmailProperty));
                if (email && ![email isEqualToString:@""]) {
                    [recordStr appendFormat:@"%@:%d;", EMAIL, 1];
                } else {
                    [recordStr appendFormat:@"%@:%d;", EMAIL, 0];
                }
                
//                NSString *email = CFBridgingRelease(ABRecordCopyValue(personRef, kABPersonEmailProperty));
//                if (email && ![email isEqualToString:@""]) {
//                    [recordStr appendFormat:@"%@:%d;", EMAIL, 1];
//                } else {
//                    [recordStr appendFormat:@"%@:%d;", EMAIL, 0];
//                }
            }
            
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"通许录授权失败" delegate:nil
                                                      cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            [alertView show];
        }
    });
}

@end
