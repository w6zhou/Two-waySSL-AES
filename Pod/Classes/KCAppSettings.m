//
//  KCAppSettings.m
//  Pods
//
//  Created by David Ma on 2015-05-26.
//

#import "KCAppSettings.h"

#define kSplashScreenKey @"splash"
#define kGalleryBannerKey @"default_gallery_banner"
#define kPromotionKey @"promotion"
#define kShippingPromotionKey @"shipping_promotion"

#define kPromotionMCEKey             @"ecommerce"
#define kPromotionMCEInStoreKey      @"in-store"
#define kPromotionESKey              @"all"

#define kIPhone4Key     @"iPhone4"
#define kIPhone5Key     @"iPhone5"
#define kIPhone6Key     @"iPhone6"
#define kIphone6PlusKey @"iPhone6Plus"

#define kIPhone4Height      480
#define kIPhone5Height      568
#define kIPhone6Height      667
#define kIPhone6PlusHeight  736



@implementation KCTranslationModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{};
}

@end

@implementation KCPromotionModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{};
}

+ (NSValueTransformer *)translationsJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[KCTranslationModel class]];
}


@end



static KCAppSettings *_appSettings = nil;

@interface KCAppSettings () {
    NSDictionary *_settings;
}
@end

@implementation KCAppSettings



+ (KCAppSettings *)instance {
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _appSettings = [[KCAppSettings alloc] init];
    });
    
    return _appSettings;
}

-(instancetype) init {
    
    self = [super init];
    if (self != nil) {
        [self initPromotions];
        
    }
    return self;
}

-(NSString*) galleryBannerImageUrl {
    return [KCAppSettings objectForKey:kGalleryBannerKey];
}
-(NSString*) splashScreenImageUrl {
    return [KCAppSettings objectForKey:kSplashScreenKey];
}

-(void) initPromotions  {
    NSDictionary *promotion = [KCAppSettings objectForKey:kPromotionKey];
    NSDictionary *shippingPromotion = [KCAppSettings objectForKey:kShippingPromotionKey];
    
    self.mceAppPromotion = [KCAppSettings promtionInDictionary:promotion withType:kPromotionMCEKey];
    
    self.mceInStorePromotion = [KCAppSettings promtionInDictionary:promotion withType:kPromotionMCEInStoreKey];
    
    self.mceAppShippingPromotion = [KCAppSettings promtionInDictionary:shippingPromotion withType:kPromotionMCEKey];
    
    self.mceInStoreShippingPromotion = [KCAppSettings promtionInDictionary:shippingPromotion withType:kPromotionMCEInStoreKey];
    
    self.esPromotion = [KCAppSettings promtionInDictionary:promotion withType:kPromotionESKey];
    
    self.esShippingPromotion = [KCAppSettings promtionInDictionary:shippingPromotion withType:kPromotionESKey];
    
}

-(void) setAppSettings:(DHAppSettings *)settings {
    
    [KCAppSettings addObject:[KCAppSettings splashScreenUrlForDeviceType:settings.splash] forKey:kSplashScreenKey];
    [KCAppSettings addObject:settings.default_gallery_banner forKey:kGalleryBannerKey];
    [KCAppSettings addObject:settings.promotion forKey:kPromotionKey];
    [KCAppSettings addObject:settings.shipping_promotion forKey:kShippingPromotionKey];
    [self initPromotions];
    
}


+(KCPromotionModel*) promtionInDictionary:(NSDictionary*)promotion withType:(NSString*)type {
    return [MTLJSONAdapter modelOfClass:[KCPromotionModel class] fromJSONDictionary:[promotion objectForKey:type] error:nil];
}


+(NSString*) splashScreenUrlForDeviceType:(NSDictionary*)types  {
    
    NSString *url = nil;
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
    CGSize result = [[UIScreen mainScreen] bounds].size;
    if(result.height == kIPhone4Height) {
        url = [types objectForKey:kIPhone4Key];
    }
    else if(result.height == kIPhone5Height) {
        url = [types objectForKey:kIPhone5Key];
    }
    else if(result.height == kIPhone6Height){
        url = [types objectForKey:kIPhone6Key];
        
    }
    else if(result.height == kIPhone6PlusHeight) {
        url = [types objectForKey:kIphone6PlusKey];
    }
#endif
    return url;
    
}

+(void) addObject:(id)object forKey:(NSString*)key {
    
    if (object != nil) {
        [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
    }
    else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
}

+(id) objectForKey:(NSString*)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

@end
