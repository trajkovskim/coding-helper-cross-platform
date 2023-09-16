import UIKit
import SwiftUI

struct StoryboardView: UIViewControllerRepresentable {
    let fileName: String
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let storyboard = UIStoryboard(name: fileName, bundle: Bundle.main)
        let controller = storyboard.instantiateInitialViewController()!
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

