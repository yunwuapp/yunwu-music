import Foundation
#if canImport(ActivityKit)
import ActivityKit

/// 播放实时活动：灵动岛 / 锁屏展示当前歌曲，点按可跳回本 App 播放页
@available(iOS 16.1, *)
enum PlaybackLiveActivity {
    private static var activity: Activity<BeansPlaybackAttributes>?

    static func sync(song: Song?, isPlaying: Bool, progress: Double, duration: Double) {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }
        guard let song else { end(); return }

        let state = BeansPlaybackAttributes.ContentState(
            songTitle: song.name,
            artist: song.artists,
            coverURL: song.coverURL?.absoluteString,
            isPlaying: isPlaying,
            progress: progress,
            duration: max(duration, song.duration)
        )

        if let activity {
            Task {
                if #available(iOS 16.2, *) {
                    await activity.update(ActivityContent(state: state, staleDate: Date().addingTimeInterval(60 * 30)))
                } else {
                    await activity.update(using: state)
                }
            }
        } else {
            do {
                activity = try Activity.request(
                    attributes: BeansPlaybackAttributes(songID: song.identityKey),
                    contentState: state,
                    pushType: nil
                )
            } catch {
                BeansLogger.shared.log("实时活动创建失败：\(error.localizedDescription)", level: .error)
            }
        }
    }

    static func end() {
        guard let activity else { return }
        self.activity = nil
        Task { await activity.end(nil, dismissalPolicy: .immediate) }
    }
}
#endif
