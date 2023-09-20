import SwiftUI

struct HScrollView<Content: View>: View {
    var title: String = ""
    var maxHeight: Double = 180;
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        VStack {
            Text(title)
                .padding(.horizontal)
                .font(.headline)
                .frame(maxWidth: .infinity, maxHeight: 20,  alignment: .leading)
            
                Spacer(minLength: 20).frame(maxHeight: 20)
            
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        Spacer(minLength: 20)
                        LazyHStack {
                            content()
                        }
                        Spacer(minLength: 20)
                    }
                }
                .frame(maxHeight: maxHeight)
        }
        .padding(.vertical)
        .background(.secondaryBackground)
    }
}

struct HScrollView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            HScrollView(title: "Title") {
                ForEach(0..<20, id: \.self) { num in
                    HTile(title: "title \(num.description)", imageName: "csharp")
                }
            }
        }
        .background(.primaryBackground)
    }
}
