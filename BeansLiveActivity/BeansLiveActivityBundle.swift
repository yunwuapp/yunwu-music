import SwiftUI
import WidgetKit
#if canImport(ActivityKit)
import ActivityKit

@main
struct BeansLiveActivityBundle: WidgetBundle {
    var body: some Widget {
        BeansPlaybackLiveActivity()
    }
}

struct BeansPlaybackLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: BeansPlaybackAttributes.self) { context in
            LockScreenPlaybackView(context: context)
                .activityBackgroundTint(Color.black.opacity(0.82))
                .widgetURL(URL(string: "yunwu://player"))
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    CoverThumb(urlString: context.state.coverURL, size: 38)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(timeText(context.state.progress))
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.secondary)
                }
                DynamicIslandExpandedRegion(.center) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(context.state.songTitle)
                            .font(.system(size: 14, weight: .semibold))
                            .lineLimit(1)
                        Text(context.state.artist)
                            .font(.system(size: 11))
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }
                DynamicIslandExpandedRegion(.bottom) {
                    HStack(spacing: 18) {
                        Image(systemName: "backward.fill")
                            .font(.system(size: 15))
                            .foregroundStyle(.white.opacity(0.75))
                        Image(systemName: context.state.isPlaying ? "pause.fill" : "play.fill")
                            .font(.system(size: 20, weight: .semibold))
                        Image(systemName: "forward.fill")
                            .font(.system(size: 15))
                            .foregroundStyle(.white.opacity(0.75))
                    }
                }
            } compactLeading: {
                Image(systemName: "music.note")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color(red: 0.42, green: 0.86, blue: 0.58))
            } compactTrailing: {
                Image(systemName: context.state.isPlaying ? "pause.fill" : "play.fill")
                    .font(.system(size: 13, weight: .semibold))
            } minimal: {
                Image(systemName: "music.note")
                    .font(.system(size: 13, weight: .semibold))
            }
            .widgetURL(URL(string: "yunwu://player"))
            .keylineTint(Color(red: 0.42, green: 0.86, blue: 0.58))
        }
    }

    private func timeText(_ seconds: Double) -> String {
        guard seconds.isFinite, seconds > 0 else { return "0:00" }
        let total = Int(seconds.rounded())
        return String(format: "%d:%02d", total / 60, total % 60)
    }
}

struct LockScreenPlaybackView: View {
    let context: ActivityViewContext<BeansPlaybackAttributes>

    var body: some View {
        HStack(spacing: 12) {
            CoverThumb(urlString: context.state.coverURL, size: 46)
            VStack(alignment: .leading, spacing: 3) {
                Text(context.state.songTitle)
                    .font(.system(size: 15, weight: .semibold))
                    .lineLimit(1)
                Text(context.state.artist)
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            Spacer(minLength: 8)
            Image(systemName: context.state.isPlaying ? "pause.fill" : "play.fill")
                .font(.system(size: 19, weight: .semibold))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .foregroundStyle(.white)
    }
}

struct CoverThumb: View {
    let urlString: String?
    let size: CGFloat

    var body: some View {
        Group {
            if let urlString, let url = URL(string: urlString) {
                AsyncImage(url: url) { phase in
                    if let image = phase.image {
                        image.resizable().scaledToFill()
                    } else {
                        placeholder
                    }
                }
            } else {
                placeholder
            }
        }
        .frame(width: size, height: size)
        .clipShape(RoundedRectangle(cornerRadius: size * 0.22, style: .continuous))
    }

    private var placeholder: some View {
        RoundedRectangle(cornerRadius: size * 0.22, style: .continuous)
            .fill(Color.white.opacity(0.14))
            .overlay(
                Image(systemName: "music.note")
                    .font(.system(size: size * 0.4))
                    .foregroundStyle(.white.opacity(0.6))
            )
    }
}
#endif
