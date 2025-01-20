import Flutter
import UIKit
import AVFoundation
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // Allow all orientations
    override func application(
        _ application: UIApplication,
        supportedInterfaceOrientationsFor window: UIWindow?
    ) -> UIInterfaceOrientationMask {
        return .landscape // Change to .portrait, .landscape .all if needed
    }
}
@objc class SpeechSynthesizer: NSObject {
    @objc static func speakText(_ text: String) {
        let synthesizer = AVSpeechSynthesizer()
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US") // Adjust language if needed
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        synthesizer.speak(utterance)
    }
}
// @objc class AppDelegate: FlutterAppDelegate {
//     override func application(
//         _ application: UIApplication,
//         didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//     ) -> Bool {
//         let controller = window?.rootViewController as! FlutterViewController
//         let speechChannel = FlutterMethodChannel(
//             name: "com.example.app/speech",
//             binaryMessenger: controller.binaryMessenger
//         )

//         speechChannel.setMethodCallHandler { (call, result) in
//             if call.method == "speakText", let args = call.arguments as? [String: Any], let text = args["text"] as? String {
//                 SpeechSynthesizer.speakText(text)
//                 result("Success")
//             } else {
//                 result(FlutterError(code: "INVALID_ARGUMENT", message: "Text not provided", details: nil))
//             }
//         }

//         return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//     }
// }
