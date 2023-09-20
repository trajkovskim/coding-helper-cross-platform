import SwiftUI

struct HTile: View {
    let title: String
    let imageName: String
    
    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .padding()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemGray4))
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(5)
        }
        .font(.subheadline)
        .frame(width: 100, height: 150)
        .cornerRadius(10)
    }
}

struct HTile_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            HScrollView(title: "Title", maxHeight: 150) {
                ForEach(0..<23) {_ in
                    HTile(title: "Title", imageName: "csharp")
                }
            }
        }.background(.primaryBackground)
    }
}
