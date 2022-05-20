import Photos
import PhotosUI
import UIKit
import SwiftUI


class ViewController: UIViewController, PHPickerViewControllerDelegate{
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        if photoCounter == maxPhotoNumber - 1{
            photoCounter = 0
            print("No more photos")
        }else{
            photoCounter += 1
            if sender.titleLabel!.text == "Like"{
                likePressedNumber += 1
                showToast(message: "Number of given likes: \(likePressedNumber)")
            }else{
                dislikePressedNumber += 1
                showToast(message: "Number of given dislikes: \(dislikePressedNumber)")
            }
        }
        imageView.image = images[photoCounter]
    }
    
    @IBAction func skipButtonPressed(_ sender: UIButton) {
        if sender.titleLabel!.text == "Next"{
            switch photoCounter{
            case maxPhotoNumber - 1:
                photoCounter = 0
            default:
                photoCounter += 1
            }
        }else{
            switch photoCounter{
            case 0:
                photoCounter = maxPhotoNumber - 1
            default:
                photoCounter -= 1
            }

        }
        imageView.image = images[photoCounter]
    }
    
    
    
    
    var photoCounter = 0
    var maxPhotoNumber = 0
    var likePressedNumber = 0
    var dislikePressedNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New Photo Picker"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        
    }
    
    @objc private func didTapAdd(){
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 3
        config.filter = .images
        let vc = PHPickerViewController(configuration: config)
        vc.delegate = self
        present(vc, animated: true)
        title = "Add more photos"
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        let group = DispatchGroup()
        
        
        results.forEach { result in
            group.enter()
            result.itemProvider.loadObject(ofClass: UIImage.self) {[weak self] reading, error in
                defer{
                    group.leave()
                }
                guard let image = reading as? UIImage, error == nil else{
                    return
                }
                self?.images.append(image)
            }
        }
        group.notify(queue: .main) {
            self.maxPhotoNumber = self.images.count
            self.imageView.image = self.images[self.photoCounter]
        }
    }
    private var images = [UIImage]()
}

extension UIViewController{
    func showToast(message: String) {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        let toastLbl = UILabel()
        toastLbl.text = message
        toastLbl.textAlignment = .center
        toastLbl.font = UIFont.systemFont(ofSize: 18)
        toastLbl.textColor = UIColor.black
        toastLbl.backgroundColor = UIColor.white
        toastLbl.numberOfLines = 0
        toastLbl.layer.borderWidth = 2
        
        let textSize = toastLbl.intrinsicContentSize
        let labelWidth = min(textSize.width, window.frame.width - 40)
        toastLbl.frame = CGRect(x: 20, y: window.frame.height - 90, width: labelWidth + 20, height: textSize.height + 10)
        toastLbl.center.x = window.center.x
        toastLbl.layer.cornerRadius = 5
        toastLbl.layer.masksToBounds = true
        
        window.addSubview(toastLbl)
        
        UIView.animate(withDuration: 3.0, animations: {
            toastLbl.alpha = 0
        }) { (_) in
            toastLbl.removeFromSuperview()
        }
    }
}
