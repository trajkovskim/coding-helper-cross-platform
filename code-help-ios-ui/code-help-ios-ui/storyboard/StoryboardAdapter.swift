import UIKit
import SwiftUI

struct StoryboardView<Content: UIViewController>: UIViewControllerRepresentable {
    let fileName: String
    
    func makeUIViewController(context: Context) -> Content {
        let storyboard = UIStoryboard(name: fileName, bundle: Bundle.main)
        let controller = storyboard.instantiateInitialViewController()! as! Content
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

