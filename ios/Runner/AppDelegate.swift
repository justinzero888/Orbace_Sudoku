import Flutter
import UIKit
import AppTrackingTransparency

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private let attChannelName = "com.orbace.orbace_sudoku/app_tracking_transparency"
  private var pendingTrackingResult: FlutterResult?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    guard let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "OrbaceATTBridge") else {
      return
    }
    let channel = FlutterMethodChannel(
      name: attChannelName,
      binaryMessenger: registrar.messenger()
    )
    channel.setMethodCallHandler { call, result in
      if call.method == "trackingAuthorizationStatus" {
        self.trackingAuthorizationStatus(result: result)
        return
      }
      guard call.method == "requestTrackingAuthorization" else {
        result(FlutterMethodNotImplemented)
        return
      }
      self.requestTrackingAuthorization(result: result)
    }
  }

  private func requestTrackingAuthorization(result: @escaping FlutterResult) {
    guard #available(iOS 14, *) else {
      result("notSupported")
      return
    }

    DispatchQueue.main.async {
      let status = ATTrackingManager.trackingAuthorizationStatus
      if status != .notDetermined {
        result(self.trackingStatusString(status))
        return
      }

      guard UIApplication.shared.applicationState == .active else {
        self.pendingTrackingResult = result
        NotificationCenter.default.addObserver(
          self,
          selector: #selector(self.requestPendingTrackingAuthorization),
          name: UIApplication.didBecomeActiveNotification,
          object: nil
        )
        return
      }

      self.presentTrackingAuthorization(result: result)
    }
  }

  @objc private func requestPendingTrackingAuthorization() {
    guard let result = pendingTrackingResult else {
      return
    }
    pendingTrackingResult = nil
    NotificationCenter.default.removeObserver(
      self,
      name: UIApplication.didBecomeActiveNotification,
      object: nil
    )
    presentTrackingAuthorization(result: result)
  }

  private func presentTrackingAuthorization(result: @escaping FlutterResult) {
    guard #available(iOS 14, *) else {
      result("notSupported")
      return
    }

    ATTrackingManager.requestTrackingAuthorization { newStatus in
      DispatchQueue.main.async {
        result(self.trackingStatusString(newStatus))
      }
    }
  }

  private func trackingAuthorizationStatus(result: @escaping FlutterResult) {
    guard #available(iOS 14, *) else {
      result("notSupported")
      return
    }
    DispatchQueue.main.async {
      result(self.trackingStatusString(ATTrackingManager.trackingAuthorizationStatus))
    }
  }

  @available(iOS 14, *)
  private func trackingStatusString(_ status: ATTrackingManager.AuthorizationStatus) -> String {
    switch status {
    case .notDetermined:
      return "notDetermined"
    case .restricted:
      return "restricted"
    case .denied:
      return "denied"
    case .authorized:
      return "authorized"
    @unknown default:
      return "unknown"
    }
  }
}
