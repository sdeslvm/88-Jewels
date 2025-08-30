import Foundation
import SwiftUI

struct JewelsEntryScreen: View {
    @StateObject private var loader: JewelsWebLoader

    init(loader: JewelsWebLoader) {
        _loader = StateObject(wrappedValue: loader)
    }

    var body: some View {
        ZStack {
            JewelsWebViewBox(loader: loader)
                .opacity(loader.state == .finished ? 1 : 0.5)
            switch loader.state {
            case .progressing(let percent):
                JewelsProgressIndicator(value: percent)
            case .failure(let err):
                JewelsErrorIndicator(err: err)  // err теперь String
            case .noConnection:
                JewelsOfflineIndicator()
            default:
                EmptyView()
            }
        }
    }
}

private struct JewelsProgressIndicator: View {
    let value: Double
    var body: some View {
        GeometryReader { geo in
            JewelsLoadingOverlay(progress: value)
                .frame(width: geo.size.width, height: geo.size.height)
                .background(Color.black)
        }
    }
}

private struct JewelsErrorIndicator: View {
    let err: String  // было Error, стало String
    var body: some View {
        Text("Ошибка: \(err)").foregroundColor(.red)
    }
}

private struct JewelsOfflineIndicator: View {
    var body: some View {
        Text("Нет соединения").foregroundColor(.gray)
    }
}
