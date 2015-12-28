//
//  KCAppSettings.h
//  Pods
//
//  Created by David Ma on 2015-05-26.
//
//

#import <Foundation/Foundation.h>
#import <KCDataHubModelTypes.h>
#import <MTLModel.h>
#import <MTLJSONAdapter.h>

@interface KCTranslationModel : MTLModel <MTLJSONSerializing>
@property(nonatomic,strong) NSDictionary *title;
@property(nonatomic,strong) NSDictionary *subtitle;
@end

@interface KCPromotionModel : MTLModel <MTLJSONSerializing>
@property(nonatomic,strong) NSString * code;
@property(nonatomic,strong) NSString * title;
@property(nonatomic,strong) NSString *subtitle;
@property(nonatomic,strong) KCTranslationModel * translations;
@end

@interface KCAppSettings : NSObject

//MCE
@property(nonatomic,strong) KCPromotionModel *mceAppPromotion;
@property(nonatomic,strong) KCPromotionModel *mceInStorePromotion;
@property(nonatomic,strong) KCPromotionModel *mceAppShippingPromotion;
@property(nonatomic,strong) KCPromotionModel *mceInStoreShippingPromotion;

//ES
@property(nonatomic,strong) KCPromotionModel *esPromotion;
@property(nonatomic,strong) KCPromotionModel *esShippingPromotion;


+(KCAppSettings*) instance;
-(void) setAppSettings:(DHAppSettings*)settigs;
-(NSString*) galleryBannerImageUrl;
-(NSString*) splashScreenImageUrl;

@end
