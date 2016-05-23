//
//  YelpBusiness.h
//  YelpSwiftApp
//
//  Created by Scott Richards on 5/17/16.
//  Copyright © 2016 Baby Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface YelpBusiness : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSURL *imageUrl;
@property (strong, nonatomic) NSString *categories;
@property (strong, nonatomic) NSString *distance;
@property (strong, nonatomic) NSURL *ratingImageUrl;
@property (strong, nonatomic) NSNumber *reviewCount;
@property (strong, nonatomic) CLLocation *location;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

+ (NSArray *)businessesFromJsonArray:(NSArray *)jsonArray;



@end
