import Foundation

extension Notification.Name {
    static let beansNeteaseLoginDidUpdate = Notification.Name("beans.netease.login.didUpdate")
    static let beansQQLoginDidUpdate = Notification.Name("beans.qq.login.didUpdate")
    static let beansKugouLoginDidUpdate = Notification.Name("beans.kugou.login.didUpdate")
    /// 灵动岛 / 锁屏实时活动点按，要求打开播放页
    static let beansOpenPlayerRequested = Notification.Name("beans.open.player.requested")
}
