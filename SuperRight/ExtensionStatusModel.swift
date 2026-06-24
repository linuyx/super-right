import Combine
import FinderSync
import Foundation

@MainActor
final class ExtensionStatusModel: ObservableObject {
    @Published private(set) var isEnabled = false

    init() {
        refresh()
    }

    func refresh() {
        isEnabled = FIFinderSyncController.isExtensionEnabled
    }

    func openExtensionSettings() {
        FIFinderSyncController.showExtensionManagementInterface()
    }
}
