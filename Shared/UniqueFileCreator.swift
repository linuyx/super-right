import Foundation

struct UniqueFileCreator {
    private let fileManager: FileManager

    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }

    @discardableResult
    func create(_ kind: FileKind, in directory: URL) throws -> URL {
        var isDirectory: ObjCBool = false
        guard directory.isFileURL,
              fileManager.fileExists(atPath: directory.path, isDirectory: &isDirectory),
              isDirectory.boolValue else {
            throw FileCreationError.invalidTarget(directory)
        }

        let data = kind.contents
        guard kind == .text || !data.isEmpty else {
            throw FileCreationError.missingTemplate(kind)
        }

        var sequence = 1
        while true {
            let suffix = sequence == 1 ? "" : "\(sequence)"
            let filename = "\(kind.defaultBaseName)\(suffix).\(kind.pathExtension)"
            let destination = directory.appendingPathComponent(filename, isDirectory: false)

            do {
                try data.write(to: destination, options: .withoutOverwriting)
                return destination
            } catch CocoaError.fileWriteFileExists {
                sequence += 1
            } catch {
                throw FileCreationError.unableToCreate(directory, error.localizedDescription)
            }
        }
    }
}
