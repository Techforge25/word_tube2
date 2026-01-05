import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {

  // Yeh function waise hi rahega
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // YEH NAYA FUNCTION ADD KIYA GAYA HAI
  // Yeh tab chalta hai jab koi doosri app aapki app ko file bhejti hai
  override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
      var drawingFilename = ""
      do {
          // Step 1: File tak temporary access haasil karein
          let isAcccessing = url.startAccessingSecurityScopedResource()
          
          // Step 2: File ka saara content (data) parh lein
          let string = try String(contentsOf: url)
          drawingFilename = (url.path as NSString).lastPathComponent
          print("Native iOS: Received file -> \(drawingFilename)")
        
          // Step 3: Apni app ke private Documents folder ka path haasil karein
          let filename = getDocumentsDirectory().appendingPathComponent(drawingFilename)

          // Step 4: File ke content ko apne private folder mein ek nayi file bana kar save karein
          do {
              try string.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
              print("Native iOS: File successfully copied to -> \(filename.path)")
          } catch {
              print("Native iOS: Failed to write file to app's directory.")
          }
          
          // Step 5: Temporary access khatam karein
          if isAcccessing {
              url.stopAccessingSecurityScopedResource()
          }

          // Step 6: Ab Flutter ko purana URL nahi, balki NAYA wala URL (jo aapke folder mein hai) bhejein
          if #available(iOS 9.0, *) {
              return super.application(app, open: filename, options: options)
          } else {
              return false
          }
      } catch {
          print("Native iOS: Unable to load data from shared file: \(error)")
          return false
      }
  }

  // YEH EK CHOTA HELPER FUNCTION HAI
  // Jo aapki app ke Documents folder ka path dhoond kar deta hai
  func getDocumentsDirectory() -> URL {
      let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
      return paths[0]
  }
}

// import Flutter
// import UIKit

// @main
// @objc class AppDelegate: FlutterAppDelegate {
//   override func application(
//     _ application: UIApplication,
//     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//   ) -> Bool {
//     GeneratedPluginRegistrant.register(with: self)
//     return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//   }
// }


