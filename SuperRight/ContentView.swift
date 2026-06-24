import AppKit
import SwiftUI

struct ContentView: View {
    @ObservedObject var statusModel: ExtensionStatusModel

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "cursorarrow.click.2")
                .font(.system(size: 58, weight: .medium))
                .foregroundStyle(.tint)

            VStack(spacing: 8) {
                Text("SuperRight")
                    .font(.largeTitle.bold())
                Text("为 Finder 右键菜单添加新建文件与拷贝路径功能")
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 10) {
                Circle()
                    .fill(statusModel.isEnabled ? Color.green : Color.orange)
                    .frame(width: 10, height: 10)
                Text(statusModel.isEnabled ? "Finder 扩展已启用" : "Finder 扩展尚未启用")
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(.quaternary, in: Capsule())

            VStack(spacing: 12) {
                if statusModel.isEnabled {
                    Button("完成并退出") {
                        NSApplication.shared.terminate(nil)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)

                    Button("打开扩展设置") {
                        statusModel.openExtensionSettings()
                    }
                    .buttonStyle(.link)

                    Text("退出 SuperRight 后，Finder 右键功能仍会继续工作。\n需要调整设置时，可从“应用程序”或 Spotlight 再次打开。")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                } else {
                    Button("打开扩展设置") {
                        statusModel.openExtensionSettings()
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)

                    Text("请在系统设置中启用 SuperRight Finder 扩展，然后返回此窗口。")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
        }
        .padding(48)
        .task {
            statusModel.refresh()

            while !Task.isCancelled {
                try? await Task.sleep(for: .milliseconds(750))
                statusModel.refresh()
            }
        }
        .animation(.easeInOut(duration: 0.2), value: statusModel.isEnabled)
    }
}
