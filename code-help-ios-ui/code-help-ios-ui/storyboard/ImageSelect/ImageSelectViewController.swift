//
//  ImageSelectViewController.swift
//  code-help-ios-ui
//
//  Created by Vangel Trajkovski on 20.9.23.
//

import UIKit
import PhotosUI

class ImageSelectViewController: UIViewController {
    
    private static var imageStorage = ProfileImageStorage.shared
    private var isDone: Bool = false
    
    var onDone: ((UIImage) -> Void)?
    var onCancel: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !isDone {
            var config = PHPickerConfiguration()
            config.selection = .default
            config.selectionLimit = 1

            let imagePicker = PHPickerViewController(configuration: config)
            
            imagePicker.delegate = self
            present(imagePicker, animated: true)
        }
    }
    
    func done(image: UIImage) {
        onDone?(image)
    }
    
    func cancel() {
        onCancel?()
    }
}
    
    
extension ImageSelectViewController: PHPickerViewControllerDelegate {
        
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        guard let result = results.first else {
            picker.dismiss(animated: true)
            self.cancel()
            return
        }
        
        if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
            result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                if let image = image as? UIImage {
                    DispatchQueue.main.async {
                        print(image)
                        self.done(image: image)
                    }
                } else {
                    print("Could not load image")
                }
            }
        }
    
        picker.dismiss(animated: true)
        self.cancel()
    }
    
}

