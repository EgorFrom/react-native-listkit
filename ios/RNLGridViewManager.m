#import <React/RCTViewManager.h>
#import "RNListKit-Swift.h"

@interface RNLGridViewManager : RCTViewManager
@end

@implementation RNLGridViewManager

RCT_EXPORT_MODULE()
// TODO: does this need to be custom?
RCT_CUSTOM_VIEW_PROPERTY(sections, NSArray<NSDictionary>, RNLGridView) {
  view.sections = [RCTConvert NSArray:json];
}
RCT_EXPORT_VIEW_PROPERTY(onSectionEndReached, RCTDirectEventBlock);

- (UIView *)view {
  return [[RNLGridView alloc] initWithBridge:self.bridge];
}

RCT_EXPORT_METHOD(getCount: (RCTResponseSenderBlock)callback) {
  NSArray *events = @[@"value1",  @"value2"];
  callback(@[[NSNull null], events]);
}

@end
