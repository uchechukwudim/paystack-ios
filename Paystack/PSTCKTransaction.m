//
//  PSTCKTransaction.m
//  Paystack
//

#import "PSTCKTransaction.h"
#import "PSTCKCard.h"
#import "NSDictionary+Paystack.h"

@interface PSTCKTransaction()
@property (nonatomic) NSString *reference;
@property (nonatomic) NSString *message;
@property (nonatomic) NSString *trans;
@property (nonatomic) NSString *redirecturl;
@property (nonatomic) NSString *status;
@property (nonatomic, readwrite, nonnull, copy) NSDictionary *allResponseFields;
@end

@implementation PSTCKTransaction

- (NSString *)description {
    return self.reference ?: self.message ?: @"Unknown reference";
}

- (NSString *)debugDescription {
    NSString *reference = self.reference ?: @"Unknown Reference";
    NSString *message = self.message ?: @"Unknown Message";
    return [NSString stringWithFormat:@"%@ (%@)", reference, message];
}

- (BOOL)isEqual:(id)object {
    return [self isEqualToTransaction:object];
}

- (NSUInteger)hash {
    return [self.reference hash];
}

- (BOOL)isEqualToTransaction:(PSTCKTransaction *)object {
    if (self == object) {
        return YES;
    }

    if (!object || ![object isKindOfClass:self.class]) {
        return NO;
    }

    return [self.reference isEqualToString:object.reference] &&[self.message isEqualToString:object.message] &&
              [self.trans isEqualToString:object.trans] ;
    
}

#pragma mark PSTCKAPIResponseDecodable

+ (NSArray *)requiredFields {
    //return @[@"id", @"livemode", @"created"];
    return @[@"status", @"message"];
}

+ (instancetype)decodedObjectFromAPIResponse:(NSDictionary *)response {
    NSDictionary *dict = [response pstck_dictionaryByRemovingNullsValidatingRequiredFields:[self requiredFields]];
    if (!dict) {
        return nil;
    }
    
    if ([[dict[@"status"] description] isEqual: @"0"]) {
        return nil;
    }
    
    PSTCKTransaction *transaction = [self new];
    transaction.reference = dict[@"reference"];
    transaction.trans = dict[@"trans"];
    transaction.redirecturl = dict[@"redirecturl"];
    transaction.message = dict[@"message"];
    transaction.status = dict[@"status"];
    
    transaction.allResponseFields = dict;
    return transaction;
}

@end
