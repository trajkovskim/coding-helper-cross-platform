import SwiftUI
import CoreData
import Authentication

struct ContentView: View {
    
    var body: some View {
        TabView {
            HomeView().tabItem {
                Label("Home", systemImage: "house.fill")
            }
            ProblemView().tabItem {
                Label("Problems", systemImage: "list.bullet.rectangle.portrait.fill")
            }
           
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AttachStubEnvironmentObjects {
            ContentView()
        }
    }
}

