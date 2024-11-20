import Foundation
import FirebaseAnalytics

final class AnalyticsManager {
    
    static let shared = AnalyticsManager()
    private init() { 
        Analytics.setAnalyticsCollectionEnabled(true)
    }
    
    func logEvent(name: String, params: [String:Any]? = nil) {
        Analytics.logEvent(name, parameters: params)
    }
    
    func logSignUp(params: [String:Any]? = nil) {
        Analytics.logEvent(AnalyticsEventSignUp, parameters: params)
    }
    
    func logLogIn(params: [String:Any]? = nil) {
        Analytics.logEvent(AnalyticsEventLogin, parameters: params)
    }
    
    func logSearch(params: [String:Any]? = nil) {
        Analytics.logEvent(AnalyticsEventSearch, parameters: params)
    }
    
    func logJoinGroup(params: [String:Any]? = nil) {
        Analytics.logEvent(AnalyticsEventJoinGroup, parameters: params)
    }
    
    func setUserId(userId: String) {
        Analytics.setUserID(userId)
    }
    
    func setUserProperty(value: String?, property: String) {
        Analytics.setUserProperty(value, forName: property)
    }
    
    func removeUserId() {
        Analytics.setUserID(nil)
    }
}
