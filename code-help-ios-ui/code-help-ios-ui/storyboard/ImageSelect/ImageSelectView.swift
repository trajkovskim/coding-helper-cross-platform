//
//  ImageSelectView.swift
//  code-help-ios-ui
//
//  Created by Vangel Trajkovski on 20.9.23.
//

import SwiftUI


struct ImageSelectView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let onImageChange: ((UIImage) -> Void)
    
    func dismiss() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        ImageSelectUIView { image in
            onImageChange(image)
            dismiss()
        } onCancel: {
            dismiss()
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct ImageSelectUIView: UIViewControllerRepresentable {
    typealias UIViewControllerType = ImageSelectViewController
    typealias DoneAction = (UIImage) -> Void
    typealias CancelAction = () -> Void
    
    private static let filename = "ImageSelect"
    
    let onDone: DoneAction
    let onCancel: CancelAction
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        let storyboard = UIStoryboard(name: Self.filename, bundle: Bundle.main)
        let controller = storyboard.instantiateInitialViewController()! as! UIViewControllerType
        
        controller.onDone = self.onDone
        controller.onCancel = self.onCancel
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
