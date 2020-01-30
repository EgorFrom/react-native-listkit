//
//  ReactNativeEventEmitter.swift
//
import Foundation

@objc(RNLEventEmitter)
open class RNLEventEmitter: RCTEventEmitter {
  
  override init() {
    super.init()
    EventEmitter.sharedInstance.registerEventEmitter(eventEmitter: self)
  }
  
  /// Base overide for RCTEventEmitter.
  ///
  /// - Returns: all supported events
  @objc open override func supportedEvents() -> [String] {
    return EventEmitter.sharedInstance.allEvents
  }
  
}
