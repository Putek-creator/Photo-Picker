//
//  ViewController.swift
//  Photo Picker
//
//  Created by Łukasz  Putkowski on 12/05/2022.
//
import Photos
import PhotosUI
import UIKit


class ViewController: UIViewController, PHPickerViewControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBAction func buttonPressed(_ sender: UIButton) {
        if photoCounter == maxPhotoNumber - 1{
            print("No more photos")
        }else{
            photoCounter += 1
            imageView.image = images[photoCounter]
        }
}
    var photoCounter = 0
    var maxPhotoNumber = 0
    
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
