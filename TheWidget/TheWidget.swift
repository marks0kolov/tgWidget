//
//  TheWidget.swift
//  TheWidget
//
//  Created by MarkSokolov on 05.08.2025.
//

import WidgetKit
import SwiftUI

// MARK: – model
struct SimpleEntry: TimelineEntry {
    let date: Date
    let message: String
}

// MARK: – timeline
struct Provider: TimelineProvider {
    private func loadMessage() -> String {
        ChannelInfo.fetch()          // call the helper in /get_chanel/get_chanel_info.swift
    }

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: .init(), message: loadMessage())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        completion(SimpleEntry(date: .init(), message: loadMessage()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        let entry = SimpleEntry(date: .init(), message: loadMessage())
        completion(Timeline(entries: [entry], policy: .never))
    }
}

// MARK: – view
struct TheWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        Text(entry.message)
            .multilineTextAlignment(.center)
            .font(.system(size: 14))
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: – widget
struct TheWidget: Widget {
    let kind = "TheWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TheWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Channel text")
        .description("Displays the string returned by get_chanel_info.main()")
        .supportedFamilies([.systemSmall])
    }
}

struct TheWidget_Previews: PreviewProvider {
    static var previews: some View {
        TheWidgetEntryView(entry: SimpleEntry(date: .init(),
                                             message: "preview\ntext"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
