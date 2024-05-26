import UIKit
import MapboxMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let resourceOptions = ResourceOptions(accessToken: "sk.eyJ1IjoiZGV2aS1wIiwiYSI6ImNsd2wzY21ubTFpam4yaW1tc3B6ajZxOW4ifQ.cJA_4AA1K1zJA030YUmR7Q")
        ResourceOptionsManager.default.resourceOptions = resourceOptions
        return true
    }
}
