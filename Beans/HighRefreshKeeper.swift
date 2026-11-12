import QuartzCore
import SwiftUI
import UIKit

/// 全局高刷新率保持器，配合 Info.plist 请求设备支持的最高刷新率。
final class HighRefreshKeeper {
    static let shared = HighRefreshKeeper()
    static let defaultsKey = "beans.enableHighRefresh"

    private var displayLink: CADisplayLink?

    private init() {}

    static func registerDefaults() {
        UserDefaults.standard.register(defaults: [defaultsKey: true])
        UserDefaults.standard.set(true, forKey: defaultsKey)
    }

    func configureFromDefaults() {
        configure(enabled: UserDefaults.standard.bool(forKey: Self.defaultsKey))
    }

    func configure(enabled: Bool) {
        UserDefaults.standard.set(enabled, forKey: Self.defaultsKey)
        if enabled {
            start()
        } else {
            stop()
        }
    }

    func attach(to view: UIView) {
        _ = view
        start()
    }

    private func start() {
        guard displayLink == nil else { return }
        let link = CADisplayLink(target: self, selector: #selector(tick))
        // 最高 120 帧、负载自适应：重毛玻璃页面负载升高时可自动降到 80/60，
        // 避免为了锁 120 而持续丢帧（锁死 120 在设置页会明显卡顿）。
        link.preferredFrameRateRange = CAFrameRateRange(
            minimum: 60,
            maximum: 120,
            preferred: 120
        )
        link.add(to: .main, forMode: .common)
        displayLink = link
    }

    private func stop() {
        displayLink?.invalidate()
        displayLink = nil
    }

    @objc private func tick() {}
}

struct HighRefreshConfigurator: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.isUserInteractionEnabled = false
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        HighRefreshKeeper.shared.attach(to: uiView)
    }
}
