import SwiftUI

struct Icon: View {
    var body: some View {
        IconStack { canvas in
            Color.black
                .edgesIgnoringSafeArea(.all)

            ZStack {
                Text("1")
                    .font(Font.system(size: canvas[300], weight: .heavy))
                    .rotationEffect(.init(degrees: 36))
                    .position(
                        x: canvas[704],
                        y: canvas[256]
                    )
                Text("2")
                    .font(Font.system(size: canvas[500], weight: .heavy))
                    .rotationEffect(.init(degrees: 132))
                    .position(
                        x: canvas[768],
                        y: canvas[768]
                    )
                Text("3")
                    .font(Font.system(size: canvas[700], weight: .heavy))
                    .rotationEffect(.init(degrees: 276))
                    .position(
                        x: canvas[192],
                        y: canvas[512]
                    )
            }
            .foregroundColor(Color.black)
            .background(Rectangle()
                .fill(
                    AngularGradient(
                        gradient: .init(stops: [
                            .init(color: Color.yellow, location: 0.2),
                            .init(color: Color.orange, location: 0.2),
                            .init(color: Color.orange, location: 0.53),
                            .init(color: Color.red, location: 0.53)
                            ]
                        ),
                        center: .init(x: 0.5, y: 0.5),
                        angle: .init(degrees: 270)
                    )
                )
            )
        }
    }
}

#if DEBUG
struct Icon_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Icon()
                .previewIcon()
                .previewLayout(.sizeThatFits)

            Icon()
                .previewHomescreen()
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.purple, .orange]),
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )
                .previewLayout(.fixed(width: 500, height: 500))
        }
    }
}
#endif
