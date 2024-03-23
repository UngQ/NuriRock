//
//  AppDelegate.swift
//  NuriRock
//
//  Created by ungQ on 3/7/24.
//

import UIKit
import FirebaseCore
import FirebaseMessaging


@main
class AppDelegate: UIResponder, UIApplicationDelegate {



	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {


		FirebaseApp.configure()


		//원격 알림 등록
		UNUserNotificationCenter.current().delegate = self

		let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
		UNUserNotificationCenter.current().requestAuthorization(
		  options: authOptions,
		  completionHandler: { _, _ in }
		)

		application.registerForRemoteNotifications()

		//메시지 대리자 설정
		Messaging.messaging().delegate = self

		//현재 등록된 토큰 가져오기. - (FCM 용 토큰임!)
		Messaging.messaging().token { token, error in
		  if let error = error {
			print("Error fetching FCM registration token: \(error)")
		  } else if let token = token {
			print("FCM registration token: \(token)")
		  }
		}

		return true
	}



	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {

		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}

	func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {

	}


}


extension AppDelegate: UNUserNotificationCenterDelegate {
	//사용자가 푸시를 클릭하고 앱이 열렸을 떄 호출되는 함수!!!!!!!!!!!!!
	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
		print(#function)
		print(response)
		print(response.notification.request.content)
	}

	//APNS 토큰과 FCM 토큰 매핑
	func application(application: UIApplication,
					 didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

		print("asdfasdf")

//		let token = deviceToken.reduce("") {
//			$0 + String(format: "%02X", $1)
//		}

		Messaging.messaging().apnsToken = deviceToken

		print(deviceToken)
	}


}


extension AppDelegate: MessagingDelegate {

	//토큰 갱신 모니터링
	func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
	  print("Firebase registration token: \(String(describing: fcmToken))")

	  let dataDict: [String: String] = ["token": fcmToken ?? ""]
	  NotificationCenter.default.post(
		name: Notification.Name("FCMToken"),
		object: nil,
		userInfo: dataDict
	  )
	  // TODO: If necessary send token to application server.
	  // Note: This callback is fired at each app startup and whenever a new token is generated.
	}


}
