import UIKit

class CameraViewController: UIViewController {

    private static var imageStorage = ProfileImageStorage.shared
    private var isDone: Bool = false
    
    var onDone: ((UIImage) -> Void)?
    var onCancel: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !isDone {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.cameraDevice = .front
            imagePicker.allowsEditing = true
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

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isDone = true
        picker.dismiss(animated: false)
        self.dismiss(animated: true)
        self.cancel()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        isDone = true
        picker.dismiss(animated: false)
        guard let image = info[.editedImage] as? UIImage else { return }
        Self.imageStorage.store(image: image)
        self.done(image: image)
    }
}
