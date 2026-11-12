import Foundation
#if canImport(ActivityKit)
import ActivityKit

/// 灵动岛 / 锁屏实时活动共享数据模型（主 App 与 Widget 扩展共用）
@available(iOS 16.1, *)
struct BeansPlaybackAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var songTitle: String
        var artist: String
        var coverURL: String?
        var isPlaying: Bool
        var progress: Double
        var duration: Double
    }

    var songID: String
}
#endif
