

import UIKit
import ReachabilitySwift
import BRYXBanner
import FBSDKCoreKit
import GoogleSignIn

import UserNotifications
import FirebaseInstanceID
import FirebaseMessaging


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{
  var window: UIWindow?
  

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
    FIRApp.configure()
    FIRDatabase.database().persistenceEnabled = true //firebase cache off
    //   FIRDatabase.setLoggingEnabled(true)
   // TimeZone. = TimeZone(identifier: "Asia/Taipei")!
 //   TimeZone.ReferenceType.default = TimeZone(abbreviation: "CST")!
    
    if #available(iOS 10.0, *) {
      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions,
        completionHandler: {_, _ in })
      
      // For iOS 10 display notification (sent via APNS)
      UNUserNotificationCenter.current().delegate = self
      // For iOS 10 data message (sent via FCM)
      FIRMessaging.messaging().remoteMessageDelegate = self
      
    } else {
      let settings: UIUserNotificationSettings =
        UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
      application.registerUserNotificationSettings(settings)
    }
    
    application.registerForRemoteNotifications()
    
    
    // Add observer for InstanceID token refresh callback.
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(self.tokenRefreshNotification),
                                           name: .firInstanceIDTokenRefresh,
                                           object: nil)

    FBSDKApplicationDelegate.sharedInstance().application(application,
                                                          didFinishLaunchingWithOptions:launchOptions)
    GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
      checkReachability()
    
    
 // 紅色漸層
//    let colorUp = UIColor(red:1.00, green:0.55, blue:0.00, alpha:1.0)
//    let colorDown =  UIColor(red:0.97, green:0.21, blue:0.00, alpha:1.0)
    
//// 紫色漸層
    let colorUp = UIColor(red:0.00, green:0.78, blue:1.00, alpha:1.0)
    let colorDown = UIColor(red:0.00, green:0.45, blue:1.00, alpha:1.0)
    
    
    let image = generateGradientImage(startColor: colorUp, endColor: colorDown)
    let appearance = UINavigationBar.appearance()
    appearance.setBackgroundImage(image, for: .default)
    
    appearance.barTintColor = UIColor(red:0.29, green:0.65, blue:0.49, alpha:1.0)
    appearance.isTranslucent = false
    appearance.tintColor = .white
    appearance.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
    


    return true
  }
  
  
  
  private func generateGradientImage(startColor: UIColor, endColor: UIColor) -> UIImage {
    let gradientLayer = CAGradientLayer()
    let sizeLength = UIScreen.main.bounds.size.height * 2
    let navBarFrame = CGRect(x: 0, y: 0, width: sizeLength, height: 64)
    gradientLayer.frame = navBarFrame
    gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    /*
     if direction == .horizontal {
     gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
     gradientLayer.endPoint = CGPoint(x: 0.3, y: 0.5)
     }
     */
    
    UIGraphicsBeginImageContext(gradientLayer.frame.size)
    gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
    let outputImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return outputImage!
  }
  

  
  
  func checkReachability() {
    let reachability = Reachability()!
    NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: ReachabilityChangedNotification,object: reachability)
    do{
      try reachability.startNotifier()
    }catch{
      print("could not start reachability notifier")
    }
  }

  func reachabilityChanged(note: NSNotification) {
  
  let reachability = note.object as! Reachability
  
  if !reachability.isReachable {
    withoutInternetMessage()
  }
}
  
  func withoutInternetMessage() {
    let banner = Banner(title: "Booking", subtitle: "Regain internet connection", image: nil, backgroundColor: .red)
    banner.dismissesOnTap = true
    banner.show(duration: 3.0)
  }
  
  
 
  func processToMainPage(){
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let mainVC = storyboard.instantiateViewController(withIdentifier: "orderlistvc")
    if let window = self.window{
      window.rootViewController = mainVC
    }
  }
  
  func processToLoginPage(){
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "login")
    if let window = self.window{
      window.rootViewController = vc
    }
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    FBSDKAppEvents.activateApp()
    connectToFcm()
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    FIRMessaging.messaging().disconnect()
    print("Disconnected from FCM.")
  }
  

  
  
  func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
    if url.scheme == "fb171324196664695" {
      return  FBSDKApplicationDelegate.sharedInstance().application(application,
                                                                    open: url,
                                                                    sourceApplication: sourceApplication,
                                                                    annotation: annotation)
    }
    
    if GIDSignIn.sharedInstance().handle(url,
                                           sourceApplication: sourceApplication,
                                           annotation: annotation) {
        return true
      }
    return true
    }
  
//for notification
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    
    // Print message ID.
    print("Message ID: \(userInfo["gcm.message_id"]!)")
    
    // Print full message.
    print("%@", userInfo)
  }
  
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                   fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    
    // Print message ID.
    print("Message ID: \(userInfo["gcm.message_id"]!)")
    
    // Print full message.
    print("%@", userInfo)
  }
  // [END receive_message]
  
  // [START refresh_token]
  func tokenRefreshNotification(_ notification: Notification) {
    if let refreshedToken = FIRInstanceID.instanceID().token() {
      print("InstanceID token: \(refreshedToken)")
    }
    
    // Connect to FCM since connection may have failed when attempted before having a token.
    connectToFcm()
  }
  // [END refresh_token]
  
  // [START connect_to_fcm]
  func connectToFcm() {
    FIRMessaging.messaging().connect { (error) in
      if error != nil {
        print("Unable to connect with FCM. \(error)")
      } else {
        print("Connected to FCM.")
      }
    }
  }
  // [END connect_to_fcm]
  
  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print("Unable to register for remote notifications ")
  }
  
  // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
  // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
  // the InstanceID token.
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    print("ANPs token retrieved: ")
    print(deviceToken)
    
    // With swizzling disabled you must set the APNs token here.
    // FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.sandbox)
  }

  
}

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
  
  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo
    // Print message ID.
    print("Message ID: \(userInfo["gcm.message_id"]!)")
    
    // Print full message.
    print("%@", userInfo)
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    // Print message ID.
    print("Message ID: \(userInfo["gcm.message_id"]!)")
    
    // Print full message.
    print("%@", userInfo)
  }
}
// [END ios_10_message_handling]

// [START ios_10_data_message_handling]
extension AppDelegate : FIRMessagingDelegate {
  // Receive data message on iOS 10 devices while app is in the foreground.
  func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
    print("%@", remoteMessage.appData)
  }
}

