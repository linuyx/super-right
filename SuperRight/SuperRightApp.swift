import AppKit
import SwiftUI

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
}

@main
struct SuperRightApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var extensionStatus = ExtensionStatusModel()

    var body: some Scene {
        WindowGroup {
            ContentView(statusModel: extensionStatus)
                .frame(minWidth: 520, minHeight: 400)
                .onChange(of: scenePhase) { _, newPhase in
                    if newPhase == .active {
                        extensionStatus.refresh()
                    }
                }
        }
        .windowResizability(.contentSize)
    }
}
