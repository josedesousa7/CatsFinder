import Foundation

extension Collection {
    subscript(safe index: Index?) -> Element? {
        guard let index else { return nil }
        return indices.contains(index) ? self[index] : nil
    }
}
